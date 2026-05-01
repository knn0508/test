# Burger Builder DevOps Platform on Azure

## How To Use This File In Prezi AI
Use this document as the production brief for a 12-slide instructor-panel presentation. The deck should feel technical, credible, and visually structured rather than flashy. The story is about a real DevOps platform in its current state, not an ideal future-state platform.

## Audience
Instructor panel evaluating DevOps architecture, automation quality, security thinking, and honesty of validation.

## Core Story
This project turns a React frontend and Spring Boot backend into a complete Azure delivery platform. Terraform provisions the infrastructure. Ansible configures hosts and deploys containers. GitHub Actions handles verification, image build and push, infrastructure automation, and certificate workflow automation. Azure Key Vault, managed identities, private SQL connectivity, and Application Gateway add the security and operations layer. HTTPS certificate automation is implemented in code and should be presented as ready, not fully demonstrated in this session.

## Prezi AI Master Prompt
Create a modern technical presentation for an instructor panel titled "Burger Builder DevOps Platform on Azure." Use a visual style that combines Azure cloud architecture diagrams, CI/CD flow graphics, and a subtle burger-layer metaphor to represent stacked DevOps layers. Keep the deck clean, high-contrast, and professional. Show progression from infrastructure foundation to deployment automation, security controls, HTTPS delivery, and validation status. Use zoom-based transitions that move from a big-picture architecture view into focused areas like Terraform, Ansible, pipelines, security, and certificate routing. Emphasize that the platform reflects the current repository state. Avoid exaggerated success claims. Show implemented automation honestly, and mark validation limits clearly.

## Global Design Direction
Design Idea: Azure blueprint meets operations control room. Use a dark slate or deep navy base with bright Azure blue, teal, and white as the main palette. Add a controlled orange accent inspired by burger ingredients only for emphasis, not as the main theme.

Color Palette:
- Background: `#0B1220`
- Secondary background: `#132238`
- Azure accent: `#0078D4`
- Teal accent: `#1FB6B8`
- Warm accent: `#F59E0B`
- Body text: `#E5EEF8`
- Muted text: `#9DB0C7`

Typography:
- Title font idea: Space Grotesk, Sora, or Montserrat
- Body font idea: Inter, IBM Plex Sans, or Manrope
- Use bold condensed titles and compact body text

Motion And Structure:
- Start with the whole platform as one system map
- Zoom into layers in this order: goal, architecture, Terraform, Ansible, CI/CD, security, HTTPS, certificate automation, fixes, validation, conclusion
- Use short path transitions instead of dramatic spins

Image Style:
- Prefer isometric cloud diagrams, vector infrastructure illustrations, clean terminal overlays, deployment arrows, shield and lock iconography, and technical cards
- Avoid generic office team photos
- Avoid cartoonish burgers as the hero image
- Keep the burger theme subtle through stacked-layer composition, not literal food imagery on every slide

Diagram Style:
- Use glowing route lines to show traffic and automation flow
- Use subnet blocks, VM cards, Key Vault, SQL, ACR, GitHub, and Application Gateway icons
- Use one consistent icon family across the deck

## Slide 1 - Project Title
Slide Goal: Open with a confident, technical identity and immediately signal that this is a full-platform DevOps presentation.

On-Slide Text:
- Burger Builder DevOps Platform on Azure
- Terraform + Ansible + GitHub Actions + Secure HTTPS Delivery
- React frontend and Spring Boot backend deployed as containers
- From application repo to automated delivery platform

Design Idea: Full-bleed hero slide with a central architecture collage. The title sits over a blueprint-style cloud map. Use a faint grid, glowing route lines, and a soft Azure edge light.

Picture Idea: A clean isometric Azure environment showing Application Gateway in front, frontend and backend VMs behind it, Key Vault and SQL to the side, and GitHub Actions feeding deployments from above.

Prezi AI Visual Prompt: Create a cinematic technical hero image showing an Azure DevOps platform for a two-tier application. Include Application Gateway, frontend VM, backend VM, ops VM, Key Vault, ACR, private SQL, and GitHub workflow cues. Use dark navy, Azure blue, teal, and white, with subtle orange highlights.

Layout Idea:
- Title centered or upper-left
- Subtitle under title
- Small system-map visual occupying the right or lower half
- Optional footer tag: "Current repo state, not idealized future state"

Speaker Notes: We built a full deployment platform for a two-tier application: a React frontend and a Spring Boot backend. The goal was not only to run the app, but to automate infrastructure, host configuration, CI/CD, secret handling, and HTTPS delivery in a way that is close to production practice.

## Slide 2 - Project Goal And Scope
Slide Goal: Define what the project had to deliver from an engineering standpoint.

On-Slide Text:
- Deploy the frontend, backend, database connectivity, and SonarQube
- Provision Azure infrastructure through Terraform
- Configure hosts and deploy containers through Ansible
- Build, test, scan, and deploy through GitHub Actions
- Expose the platform through Application Gateway with HTTPS

Design Idea: Use a layered stack graphic. Each layer represents a responsibility: infrastructure, configuration, CI/CD, security, and delivery.

Picture Idea: A five-layer visual stack, with each layer labeled and supported by matching icons: Terraform, Ansible, GitHub Actions, Key Vault and identities, and Application Gateway.

Prezi AI Visual Prompt: Build a layered DevOps capability stack for an Azure platform. Each layer should represent infrastructure, configuration management, CI/CD, secrets and identity, and secure ingress. The look should be clean, structured, and slightly futuristic.

Layout Idea:
- Left: vertical layered stack or stepped pyramid
- Right: concise bullets
- Use small icon chips beside each bullet

Speaker Notes: The scope covers the full deployment lifecycle. Terraform provisions Azure infrastructure, Ansible configures and deploys the application hosts, GitHub Actions builds and deploys the app, Azure Key Vault stores secrets, and Application Gateway acts as the secure public entry point.

## Slide 3 - Architecture Overview
Slide Goal: Show the platform topology clearly enough that the audience can understand network boundaries and component roles.

On-Slide Text:
- One Azure resource group contains the full environment
- VNet segmented into gateway, frontend, backend, data, and ops subnets
- Frontend VM, backend VM, and ops VM each have distinct responsibilities
- Azure SQL is private through a private endpoint and private DNS
- ACR, Key Vault, Application Insights, and Application Gateway complete the platform

Design Idea: This should be the cleanest architecture diagram in the deck. Use subnet containers laid out horizontally or diagonally, with traffic arrows and trust boundaries.

Picture Idea: A stylized Azure network diagram with five subnet zones, Application Gateway at the edge, private VMs behind it, and SQL in a locked private data zone.

Prezi AI Visual Prompt: Create an Azure architecture diagram for a DevOps deployment platform with one resource group, one VNet, and five subnets: gateway, frontend, backend, data, and ops. Show Application Gateway at the edge, frontend and backend VMs on private IPs, an ops VM, Azure SQL over private endpoint, Key Vault, ACR, and Application Insights.

Layout Idea:
- Center: architecture diagram
- Side callouts: short labels for public edge, private app tier, data tier, and ops tier
- Keep labels short and readable from a distance

Speaker Notes: The environment is segmented into dedicated subnets. Only Application Gateway is public for application traffic, while the application VMs use private IPs. The backend connects to Azure SQL through a private endpoint, and the ops VM serves as the internal automation runner, SonarQube host, and ACME challenge endpoint.

## Slide 4 - Infrastructure As Code With Terraform
Slide Goal: Explain that infrastructure is codified, modular, and feeds deployment automation.

On-Slide Text:
- Terraform modules cover networking, VMs, SQL, monitoring, Key Vault, and Application Gateway
- Azure Storage backend holds the remote state
- Outputs provide host IPs, ACR details, Key Vault name, subnet CIDRs, and frontend origin
- Application Gateway can operate in HTTP-only or HTTPS-enabled mode

Design Idea: Present Terraform as a control plane. Show module tiles feeding outputs into downstream deployment tools.

Picture Idea: A central Terraform cube or blueprint file fanning out into modules, with arrows from outputs toward Ansible and GitHub Actions.

Prezi AI Visual Prompt: Create a modular infrastructure-as-code visual centered on Terraform. Show distinct modules for networking, compute, SQL, monitoring, Key Vault, and Application Gateway. Show outputs flowing into deployment automation. Use a blueprint and control-panel aesthetic.

Layout Idea:
- Top row: module cards
- Bottom row: important outputs
- Side annotation: "single source of infrastructure truth"

Speaker Notes: Terraform is the infrastructure source of truth. The modules separate concerns clearly, and outputs such as private IPs, Key Vault name, ACR login server, and frontend origin are consumed later by deployment automation. This removed hardcoded infrastructure values from Ansible and CI.

## Slide 5 - Configuration And Deployment With Ansible
Slide Goal: Show that deployment is dynamic and tied directly to infrastructure state.

On-Slide Text:
- `site.yml` builds an in-memory inventory from `terraform output -json`
- No static inventory files act as the source of truth
- Roles cover common setup, Docker, frontend, backend, and SonarQube
- Target VMs log in with managed identity and pull images from ACR
- Backend and SonarQube read secrets from Key Vault during deployment

Design Idea: Use a pipeline or branching tree from Terraform outputs into three hosts: frontend, backend, and ops. Each host then gets its role bundle.

Picture Idea: A deployment orchestration diagram showing Terraform outputs becoming live Ansible host definitions, then role execution on each VM.

Prezi AI Visual Prompt: Create an automation diagram where Terraform outputs feed Ansible dynamic inventory, then Ansible applies roles to frontend, backend, and ops hosts. Show Docker setup, image pulls from ACR, and Key Vault secret retrieval through managed identity.

Layout Idea:
- Left: Terraform output block
- Center: dynamic inventory and role flow
- Right: three VM cards with assigned roles

Speaker Notes: Ansible no longer depends on handwritten host files. It reads Terraform outputs and constructs inventory dynamically, which keeps Terraform as the single source of truth. The target VMs authenticate with managed identity for Azure and ACR access, and the backend and SonarQube roles fetch secrets directly from Key Vault instead of embedding credentials in the repository.

## Slide 6 - CI/CD Pipeline Design
Slide Goal: Show how workflows are separated by responsibility and where they execute.

On-Slide Text:
- `backend.yml` verifies, scans, builds, pushes, and deploys the backend
- `frontend.yml` verifies, scans, builds, pushes, and deploys the frontend
- `infra.yml` handles Terraform format, init, validate, plan, and apply
- `iac-validation.yml` isolates pull-request IaC checks
- `appgw-certificate.yml` handles certificate issue-or-renew on the ops runner

Design Idea: A workflow map with two lanes. One lane is GitHub-hosted verification. The second lane is self-hosted private-network execution for deployment tasks.

Picture Idea: GitHub logo at the left feeding five workflow cards. Verification jobs remain in a public runner lane; deploy and certificate jobs move into a secure private runner lane.

Prezi AI Visual Prompt: Create a CI/CD workflow diagram for GitHub Actions with separate tracks for verification, infrastructure, deployment, and certificate automation. Distinguish GitHub-hosted runner tasks from self-hosted ops-runner tasks inside a private Azure network.

Layout Idea:
- Horizontal timeline or swimlane diagram
- Use tags like "PR validation," "main branch deploy," and "private runner"
- Highlight separation of duties visually

Speaker Notes: The pipelines are split by responsibility. Pull-request verification runs on GitHub-hosted runners, while image push and deployment run only on the self-hosted ops runner inside the private network. Infrastructure uses a separate Terraform workflow with OIDC login to Azure, and certificate issuance is isolated into its own automation path.

## Slide 7 - Security Design
Slide Goal: Present security as a design choice embedded across identity, secrets, network, and ingress.

On-Slide Text:
- Frontend, backend, and ops VMs use system-assigned managed identities
- Application Gateway uses a user-assigned identity for Key Vault certificate access
- `AcrPull` goes to frontend and backend VMs, while ops gets `AcrPush`
- Key Vault policies separate secret reading from certificate management
- Azure SQL disables public access and stays behind a private endpoint

Design Idea: Use a shield-centered slide with four surrounding zones: identity, registry, secrets, and private data access.

Picture Idea: A shield or policy hub in the middle connected to managed identities, Key Vault, SQL private endpoint, and Application Gateway certificate retrieval.

Prezi AI Visual Prompt: Create a security architecture illustration for an Azure DevOps platform. Show managed identities, ACR role assignments, Key Vault secret access, Application Gateway certificate access, and Azure SQL private networking. Use shield and lock motifs sparingly and professionally.

Layout Idea:
- Center: security hub graphic
- Around it: four labeled capability areas
- Add one small note: "minimize static credentials"

Speaker Notes: The security model avoids static application credentials where possible. Frontend and backend VMs pull images through managed identity, the ops runner can push images, Application Gateway reads its TLS certificate from Key Vault, and the database is not exposed publicly. The public entry point is narrowed to the gateway rather than the application VMs themselves.

## Slide 8 - Traffic Flow And HTTPS
Slide Goal: Explain how user traffic is routed and where HTTPS fits into the ingress design.

On-Slide Text:
- Public requests enter through Azure Application Gateway
- `/.well-known/acme-challenge/*` routes to the ops VM on port `8089`
- `/api/*` routes to the backend VM on port `8080`
- All other traffic routes to the frontend VM on port `80`
- When enabled, HTTP redirects permanently to HTTPS
- Default hostname story uses generated `sslip.io`

Design Idea: This slide should be a traffic map. Use arrows with different colors for frontend traffic, API traffic, and ACME challenge traffic.

Picture Idea: Public internet cloud feeding Application Gateway, then three routing arrows: frontend, backend, and ACME validation path. A lock icon appears on the HTTPS route.

Prezi AI Visual Prompt: Create a traffic routing diagram centered on Azure Application Gateway. Show a public request entering, one path going to the frontend VM, one path to `/api/*` on the backend VM, and one ACME challenge path to the ops VM on port 8089. Show HTTP redirecting to HTTPS and use an `sslip.io` hostname label.

Layout Idea:
- Left: user and internet edge
- Center: Application Gateway
- Right: three destination routes
- Use labels directly on arrows

Speaker Notes: The ingress path is now HTTPS-ready. If no custom hostname is provided, the gateway defaults to a generated `sslip.io` hostname based on its public IP. HTTP redirects to HTTPS only after a certificate is present, and traffic is split cleanly between frontend, backend, and the ACME challenge path.

## Slide 9 - Automated Certificate Issuance
Slide Goal: Make the certificate story concrete and credible without claiming it was already demonstrated end to end.

On-Slide Text:
- `appgw-certificate.yml` runs on the self-hosted ops runner
- `scripts/issue_appgw_certificate.sh` starts a temporary ACME webroot server on port `8089`
- Let’s Encrypt issues the certificate for the Application Gateway hostname
- The certificate is converted to PFX and imported into Azure Key Vault
- Terraform is then applied with HTTPS enabled so Application Gateway attaches the certificate
- Implemented in code and ready to run

Design Idea: Use a numbered automation chain with five steps and a "ready, not demonstrated here" status ribbon.

Picture Idea: A clean step-by-step automation ribbon: GitHub workflow -> ops runner -> ACME challenge -> Key Vault import -> Application Gateway HTTPS.

Prezi AI Visual Prompt: Create a certificate automation sequence for Azure Application Gateway using GitHub Actions, an ops runner, Let’s Encrypt, Key Vault, and Terraform. The visual should emphasize that the workflow is fully designed and coded, but not fully executed in this session.

Layout Idea:
- Horizontal or circular five-step process
- Final badge: "Code complete, session execution pending"
- Optional mini-callout: "browser-trusted TLS"

Speaker Notes: To automate browser-trusted TLS, we added an ACME challenge route through Application Gateway to the ops VM. The certificate workflow uses Let’s Encrypt, imports the result into Key Vault, and then enables HTTPS on the gateway. In this presentation, we should describe that flow as implemented in code and ready to run, not as something fully executed in this session.

## Slide 10 - Problems Found And Fixed
Slide Goal: Show engineering maturity by highlighting meaningful operational fixes rather than cosmetic changes.

On-Slide Text:
- Dynamic inventory bootstrap now works correctly with `--limit`
- ProxyJump logic was corrected for the self-hosted runner inside the VNet
- A backend health probe was added at `/api/health`
- CI was split into verification and deployment stages
- Azure OIDC was added to the Terraform workflow
- HTTPS and certificate automation were added as a new deployment capability

Design Idea: Use a before-and-after or issue-to-fix grid. Each problem is paired with a precise correction.

Picture Idea: Six small cards, each showing an issue icon on top and a fix outcome below. Keep it crisp and technical.

Prezi AI Visual Prompt: Create a technical improvement slide showing operational problems and fixes in a DevOps platform. Use clean issue-to-solution cards for inventory bootstrap, SSH pathing, health probes, CI stage separation, OIDC auth, and HTTPS automation.

Layout Idea:
- Two-column grid: issue and fix
- Avoid long paragraphs on the slide
- Use micro-icons: wrench, pipeline, route, identity, health, certificate

Speaker Notes: A significant part of the work was correcting deployment logic that looked organized but would fail in practice. The fixes focused on making the pipeline operational, not only tidy: inventory bootstrap, internal SSH routing, gateway health checks, authentication, and certificate automation.

## Slide 11 - Validation Status
Slide Goal: Present verification honestly and protect credibility by separating what was reviewed, what was syntax-checked, and what could not be run here.

On-Slide Text:
- Static repo review completed against the current worktree
- `Presentation.md` was empty before this presentation content was created
- Ansible syntax-check succeeded after redirecting temp paths to `/tmp`
- Terraform validation could not complete locally because provider download from `registry.terraform.io` was blocked by network policy
- No end-to-end apply, deploy, or certificate issuance was run in this session

Design Idea: Use a verification scoreboard with three states: confirmed, blocked by environment, and not executed in session.

Picture Idea: A dashboard-style slide with green, amber, and gray status chips. Green for repo review and Ansible syntax-check. Amber for Terraform validation blocked by provider download restrictions. Gray for end-to-end runtime steps not executed.

Prezi AI Visual Prompt: Create a validation status dashboard for a DevOps presentation. Use clear status categories such as confirmed, blocked by environment, and not executed in session. The design should look honest, professional, and audit-friendly.

Layout Idea:
- Center: status board
- Side note: "present current evidence, not assumptions"
- Use minimal text but strong state labels

Speaker Notes: We should present the validation status clearly. The configuration has been reviewed and the main logic issues were addressed. Ansible syntax-check passes in this environment when temp paths are redirected away from the default home-directory location. Terraform and certificate issuance were not executed here because provider downloads are blocked by environment network restrictions, so the HTTPS path should be presented as implemented and ready to run.

## Slide 12 - Conclusion And Next Steps
Slide Goal: End with the business value of the engineering work and a practical next milestone.

On-Slide Text:
- Infrastructure, deployment, secrets, and HTTPS automation are now connected into one platform
- The repository is materially closer to production-style delivery than the starting baseline
- The next milestone is to run the GitHub workflows in Azure and verify the full path end to end
- Future improvements: HA scaling, private Key Vault networking, and a custom domain beyond `sslip.io`

Design Idea: Return to the architecture map from Slide 1, but now show checkmarks or highlighted layers to imply maturity and direction.

Picture Idea: A polished system overview with the entire stack connected, plus a subtle forward arrow toward scaling and hardening.

Prezi AI Visual Prompt: Create a closing slide for a DevOps platform presentation that shows a complete Azure delivery stack with clear progress and future hardening opportunities. Keep it optimistic but grounded in actual implementation status.

Layout Idea:
- Left: short conclusion points
- Right: refined overview graphic
- End with one strong closing line in larger text

Closing Line Idea:
- "From code repository to secure delivery platform"

Speaker Notes: The final result is a substantially improved deployment platform with clear infrastructure ownership, dynamic configuration, managed-identity-based access, and automated HTTPS support. The next real milestone is running the workflows end to end in GitHub and Azure. After that, the platform can be hardened further with high availability and deeper network isolation.

## Presentation Tips For Prezi AI
Use these settings when generating or refining the deck:

- Keep each slide visually dominated by one diagram or one strong composition
- Prefer icons and diagrams over screenshots unless you have a clean GitHub Actions screenshot worth showing
- If Prezi AI generates generic stock people, remove them
- Keep text density moderate so the deck stays presentation-friendly
- Use zoom transitions to move logically from platform overview to internal subsystems
- Reuse the same architecture objects across slides so the deck feels like one system being explored
- If you need a single unifying motif, use stacked layers or route lines rather than burger photos

## Optional Short Prompt To Paste Into Prezi AI
Build a 12-slide technical presentation for an instructor panel about a project called "Burger Builder DevOps Platform on Azure." The presentation should show a real DevOps platform for a React frontend and Spring Boot backend using Terraform, Ansible, GitHub Actions, Azure Key Vault, managed identities, Azure SQL private endpoint, Azure Container Registry, and Azure Application Gateway. Include an HTTPS and certificate automation story using `sslip.io`, Let’s Encrypt, Key Vault import, and Terraform re-apply. Make the design modern, structured, and diagram-heavy with dark navy, Azure blue, teal, white, and small orange accents. Use zoom transitions and architecture visuals. Emphasize the current repository state, and clearly distinguish implemented automation from validation actually executed in this session.
