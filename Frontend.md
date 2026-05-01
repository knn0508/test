React + TypeScript + Vite SPA + Docker + Pipeline
Use the existing SPA, serve it via Nginx in Docker, let App Gateway route `/api/*` to the backend, and automate deployments.

Phase 1
React + Vite + TypeScript App
~3 hours

1.1
Use the existing Vite project

```bash
cd frontend
npm install
npm run lint
npm run test -- --run
npm run build
```

1.2
Configure local development backend URL
Use `frontend/.env.local` for local development only:

```dotenv
VITE_API_BASE_URL=http://localhost:8080
```

The current repo does not need a Vite proxy for production. App Gateway handles `/api/*` routing in Azure. `VITE_API_BASE_URL` is only for local development.

1.3
Use same-origin API calls for production
File: `frontend/src/services/api.ts`

```ts
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL?.trim() || '';

// Existing calls already include /api, for example:
apiClient.get('/api/ingredients');
apiClient.post('/api/cart/items', payload);
```

Leave `VITE_API_BASE_URL` unset in production so the browser calls the same App Gateway host. For local development only, set it to `http://localhost:8080`.

Phase 2
Dockerize with Multi-Stage Build + Nginx
~1 hour

Add `frontend/Dockerfile`:

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.27-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Keep `frontend/nginx.conf` as a static SPA server only:

```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    error_page 404 /index.html;
}
```

The frontend Nginx does not proxy `/api/*`. App Gateway owns that routing. For local browser-to-backend testing, use `frontend/.env.local` with `VITE_API_BASE_URL=http://localhost:8080`.

Phase 3
Frontend GitHub Actions Pipeline
~2 hours

Add `.github/workflows/frontend.yml`.

Requirements:

- Run build, lint, and test on `ubuntu-latest` for both pushes and pull requests
- Run image push and deployment on the self-hosted ops runner only for pushes to `main`
- Read ACR details from Terraform outputs instead of hardcoding them
- Use managed-identity Azure login on `main`
- Build and push `frontend:${GITHUB_SHA}` and `frontend:latest`
- Deploy with `ansible-playbook config/ansible/site.yml --limit "localhost,frontend_vms"`
- Do not use static Ansible inventory files
- Let Ansible build inventory from `terraform output -json`

Suggested workflow shape:

```yaml
name: Frontend CI/CD

on:
  push:
    branches: [main]
    paths:
      - .github/workflows/frontend.yml
      - frontend/**
  pull_request:
    paths:
      - .github/workflows/frontend.yml
      - frontend/**
```

Deployment notes:

- Frontend image push and Ansible deploy run on the self-hosted runner only on `main`
- Pull request checks do not need the self-hosted runner
- SonarQube can run on `main` from that same runner
- The deploy path reuses the existing `frontend_deploy` Ansible role
- Set `ANSIBLE_USE_BASTION=false` when the deploy command runs on the ops runner inside the VNet
- Terraform remains the source of truth for ACR naming and host targeting
