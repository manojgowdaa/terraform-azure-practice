// API service — all backend calls go through here
const API_BASE = "https://webapp-linux-tf2026-3.azurewebsites.net";

export async function fetchProducts() {
  const response = await fetch(`${API_BASE}/products`);
  if (!response.ok) throw new Error("Failed to fetch products");
  return response.json();
}

export async function placeOrder(cartItems, userId) {
  const items = cartItems.map((item) => ({
    product_id: item.id,
    quantity: item.quantity,
  }));

  const url = userId
    ? `${API_BASE}/orders?user_id=${userId}`
    : `${API_BASE}/orders`;

  const response = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ items }),
  });

  if (!response.ok) throw new Error("Failed to place order");
  return response.json();
}

export async function fetchOrders() {
  const response = await fetch(`${API_BASE}/orders`);
  if (!response.ok) throw new Error("Failed to fetch orders");
  return response.json();
}

export async function fetchUserOrders(userId) {
  const response = await fetch(`${API_BASE}/orders?user_id=${userId}`);
  if (!response.ok) throw new Error("Failed to fetch orders");
  return response.json();
}

export async function register(name, email, password) {
  const response = await fetch(`${API_BASE}/auth/register`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name, email, password }),
  });
  const data = await response.json();
  if (!response.ok) throw new Error(data.detail || "Registration failed");
  return data;
}

export async function login(email, password) {
  const response = await fetch(`${API_BASE}/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  const data = await response.json();
  if (!response.ok) throw new Error(data.detail || "Login failed");
  return data;
}
