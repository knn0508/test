import { describe, it, expect, vi, beforeEach } from 'vitest';
import axios from 'axios';
import type { Ingredient, CartItem, Order, IngredientsResponse } from '../types';

vi.mock('axios');

const mockedAxios = vi.mocked(axios, true);

const mockAxiosInstance = {
  get: vi.fn(),
  post: vi.fn(),
  delete: vi.fn(),
};

const loadApiModule = async () => {
  mockedAxios.create.mockReturnValue(mockAxiosInstance as any);
  return import('./api');
};

describe('API Service', () => {
  beforeEach(() => {
    vi.resetModules();
    vi.clearAllMocks();
    vi.unstubAllEnvs();
    mockAxiosInstance.get.mockReset();
    mockAxiosInstance.post.mockReset();
    mockAxiosInstance.delete.mockReset();
    mockedAxios.create.mockReturnValue(mockAxiosInstance as any);
  });

  it('should use same-origin API calls when VITE_API_BASE_URL is blank', async () => {
    vi.stubEnv('VITE_API_BASE_URL', '');

    await loadApiModule();

    expect(mockedAxios.create).toHaveBeenCalledWith({
      baseURL: '',
      headers: {
        'Content-Type': 'application/json',
      },
    });
  });

  it('should use the configured VITE_API_BASE_URL for local development', async () => {
    vi.stubEnv('VITE_API_BASE_URL', 'http://localhost:8080');

    await loadApiModule();

    expect(mockedAxios.create).toHaveBeenCalledWith({
      baseURL: 'http://localhost:8080',
      headers: {
        'Content-Type': 'application/json',
      },
    });
  });

  describe('getIngredients', () => {
    it('should fetch all ingredients', async () => {
      const { getIngredients } = await loadApiModule();

      const mockResponse: IngredientsResponse = {
        buns: [],
        patties: [],
        toppings: [],
        sauces: [],
      };

      mockAxiosInstance.get.mockResolvedValue({ data: mockResponse });

      const result = await getIngredients();
      expect(result).toEqual(mockResponse);
      expect(mockAxiosInstance.get).toHaveBeenCalledWith('/api/ingredients');
    });
  });

  describe('getIngredientsByCategory', () => {
    it('should fetch ingredients by category', async () => {
      const { getIngredientsByCategory } = await loadApiModule();

      const mockIngredients: Ingredient[] = [
        {
          id: 1,
          name: 'Beef Patty',
          category: 'patties',
          price: 5.99,
          imageUrl: 'patty.jpg',
        },
      ];

      mockAxiosInstance.get.mockResolvedValue({ data: mockIngredients });

      const result = await getIngredientsByCategory('patties');
      expect(result).toEqual(mockIngredients);
      expect(mockAxiosInstance.get).toHaveBeenCalledWith('/api/ingredients/patties');
    });
  });

  describe('addToCart', () => {
    it('should add item to cart', async () => {
      const { addToCart } = await loadApiModule();

      const mockItem = {
        sessionId: 'session_123',
        ingredientId: 1,
        quantity: 1,
      };

      const mockResponse: CartItem = {
        id: 1,
        layers: [{ ingredientId: 1, quantity: 2 }],
        totalPrice: 10.99,
        quantity: mockItem.quantity,
      };

      mockAxiosInstance.post.mockResolvedValue({ data: mockResponse });

      const result = await addToCart(mockItem);
      expect(result).toEqual(mockResponse);
      expect(mockAxiosInstance.post).toHaveBeenCalledWith('/api/cart/items', mockItem);
    });
  });

  describe('getCart', () => {
    it('should fetch cart items by session id', async () => {
      const { getCart } = await loadApiModule();

      const sessionId = 'test_session_123';
      const mockCart: CartItem[] = [
        {
          id: 1,
          layers: [{ ingredientId: 1, quantity: 2 }],
          totalPrice: 10.99,
          quantity: 1,
        },
      ];

      mockAxiosInstance.get.mockResolvedValue({ data: mockCart });

      const result = await getCart(sessionId);
      expect(result).toEqual(mockCart);
      expect(mockAxiosInstance.get).toHaveBeenCalledWith(`/api/cart/${sessionId}`);
    });
  });

  describe('removeCartItem', () => {
    it('should remove item from cart', async () => {
      const { removeCartItem } = await loadApiModule();

      const itemId = 1;

      mockAxiosInstance.delete.mockResolvedValue({});

      await removeCartItem(itemId);
      expect(mockAxiosInstance.delete).toHaveBeenCalledWith(`/api/cart/items/${itemId}`);
    });
  });

  describe('createOrder', () => {
    it('should create a new order', async () => {
      const { createOrder } = await loadApiModule();

      const orderData = {
        sessionId: 'session_123',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '1234567890',
        cartItemIds: [1, 2],
      };

      const mockOrder: Order = {
        id: 1,
        orderNumber: 'order_123',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '1234567890',
        totalAmount: 10.99,
        status: 'PENDING',
        createdAt: new Date().toISOString(),
      };

      mockAxiosInstance.post.mockResolvedValue({ data: mockOrder });

      const result = await createOrder(orderData);
      expect(result).toEqual(mockOrder);
      expect(mockAxiosInstance.post).toHaveBeenCalledWith('/api/orders', orderData);
    });
  });

  describe('getOrder', () => {
    it('should fetch order by id', async () => {
      const { getOrder } = await loadApiModule();

      const orderId = 'order_123';
      const mockOrder: Order = {
        id: 1,
        orderNumber: orderId,
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '1234567890',
        totalAmount: 10.99,
        status: 'DELIVERED',
        createdAt: new Date().toISOString(),
      };

      mockAxiosInstance.get.mockResolvedValue({ data: mockOrder });

      const result = await getOrder(orderId);
      expect(result).toEqual(mockOrder);
      expect(mockAxiosInstance.get).toHaveBeenCalledWith(`/api/orders/${orderId}`);
    });
  });

  describe('getOrderHistory', () => {
    it('should fetch order history with optional email filter', async () => {
      const { getOrderHistory } = await loadApiModule();
      const mockOrders: Order[] = [];

      mockAxiosInstance.get.mockResolvedValue({ data: mockOrders });

      const result = await getOrderHistory('john@example.com');
      expect(result).toEqual(mockOrders);
      expect(mockAxiosInstance.get).toHaveBeenCalledWith('/api/orders/history', {
        params: { email: 'john@example.com' },
      });
    });
  });
});
