# 🍔 Burger Builder - Frontend

A modern, responsive burger ordering application built with React, TypeScript, and Vite.

## Features

- **Interactive Burger Builder**: Visually build custom burgers with drag-and-drop ingredient selection
- **Smart Cart Management**: Add, remove, and modify burger quantities with real-time price updates
- **Responsive Design**: Optimized for mobile, tablet, and desktop experiences
- **Order Management**: Complete checkout flow with customer details and order confirmation
- **Local Storage Persistence**: Cart data is saved across browser sessions
- **Modern UI/UX**: Beautiful gradients, smooth animations, and intuitive interface

## Tech Stack

- **React 18** with **TypeScript**
- **Vite** for fast development and building
- **React Router DOM** for navigation
- **Axios** for API integration
- **Context API** for state management
- **CSS Modules** for component styling

## Project Structure

```
frontend/
├── src/
│   ├── components/
│   │   ├── BurgerBuilder/    # Burger creation interface
│   │   ├── Cart/              # Shopping cart functionality
│   │   ├── Ingredients/       # Ingredient selection UI
│   │   ├── Layout/            # Header and layout components
│   │   └── OrderSummary/      # Checkout and order confirmation
│   ├── context/
│   │   ├── CartContext.tsx           # Global cart state
│   │   └── BurgerBuilderContext.tsx  # Burger builder state
│   ├── services/
│   │   └── api.ts             # API client and endpoints
│   ├── types/
│   │   └── index.ts           # TypeScript interfaces
│   ├── utils/
│   │   └── sessionManager.ts # Session ID management
│   ├── App.tsx                # Main app with routing
│   ├── App.css
│   ├── index.css              # Global styles
│   └── main.tsx               # App entry point
├── public/
├── package.json
├── tsconfig.json
├── vite.config.ts
└── README.md
```

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- npm or yarn

### Installation

1. Install dependencies:
```bash
npm install
```

2. Create environment variables for local development:
Create a `.env.local` file in the `frontend/` directory:
```
VITE_API_BASE_URL=http://localhost:8080
```

3. Start the development server:
```bash
npm run dev
```

The app will be available at `http://localhost:5173`

Leave `VITE_API_BASE_URL` unset in production when the SPA is served behind the same App Gateway host as the backend API.

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint
- `npm test` - Run tests in watch mode
- `npm run test:ui` - Run tests with UI
- `npm run test:coverage` - Run tests with coverage report

## Testing

The project uses **Vitest** and **React Testing Library** for comprehensive unit testing.

### Test Coverage

- **46 tests** covering:
  - ✅ Session management utilities (6 tests)
  - ✅ Cart context operations (11 tests)
  - ✅ Burger builder context (13 tests)
  - ✅ Component rendering and interactions (9 tests)
  - ✅ API service calls (7 tests)

### Running Tests

```bash
# Run tests in watch mode
npm test

# Run tests once (CI mode)
npm test -- --run

# View test UI
npm run test:ui

# Generate coverage report
npm run test:coverage
```

### Test Files

- `src/utils/sessionManager.test.ts` - Session ID generation and clearing
- `src/context/CartContext.test.tsx` - Cart state management
- `src/context/BurgerBuilderContext.test.tsx` - Burger building logic
- `src/components/Ingredients/IngredientCard.test.tsx` - Component rendering
- `src/services/api.test.ts` - API client functionality

## API Integration

The frontend expects a backend API with the following endpoints:

### Ingredients
- `GET /api/ingredients` - Get all ingredients
- `GET /api/ingredients/{category}` - Get ingredients by category

### Cart
- `POST /api/cart/items` - Add item to cart
- `GET /api/cart/{sessionId}` - Get cart items
- `DELETE /api/cart/items/{itemId}` - Remove cart item

### Orders
- `POST /api/orders` - Create new order
- `GET /api/orders/{orderId}` - Get order details

## Component Overview

### BurgerBuilder
The main component for creating custom burgers. Features:
- Categorized ingredient selection
- Visual burger preview
- Real-time price calculation
- Add to cart functionality

### Cart
Shopping cart management with:
- Item quantity controls
- Remove items
- Price summary with tax
- Checkout navigation

### OrderSummary
Checkout page with:
- Customer details form
- Order review
- Order confirmation
- Form validation

## State Management

The app uses React Context API for global state:

- **CartContext**: Manages shopping cart state and localStorage persistence
- **BurgerBuilderContext**: Manages burger customization state

## Styling

- Modern gradient backgrounds
- Smooth animations and transitions
- Responsive grid layouts
- Mobile-first design approach
- Consistent color scheme (purple/blue gradient theme)

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Demo Mode

If the backend API is not available, the app will automatically use sample ingredient data for demonstration purposes.

## Future Enhancements

- User authentication
- Order history
- Payment integration
- Burger templates/favorites
- Nutritional information
- Image uploads for custom ingredients

## License

MIT
