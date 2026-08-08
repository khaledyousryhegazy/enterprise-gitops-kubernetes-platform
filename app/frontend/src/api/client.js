const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4000/api';

async function request(path, { method = 'GET', body, token } = {}) {
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers.Authorization = `Bearer ${token}`;

  const res = await fetch(`${API_URL}${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });

  const data = await res.json().catch(() => ({}));

  if (!res.ok) {
    throw new Error(data.error || `Request failed with status ${res.status}`);
  }

  return data;
}

export const api = {
  register: (payload) => request('/auth/register', { method: 'POST', body: payload }),
  login: (payload) => request('/auth/login', { method: 'POST', body: payload }),
  me: (token) => request('/auth/me', { token }),

  getItems: (token) => request('/items', { token }),
  getAllItems: (token) => request('/items/all', { token }),
  createItem: (payload, token) => request('/items', { method: 'POST', body: payload, token }),
  updateItem: (id, payload, token) =>
    request(`/items/${id}`, { method: 'PATCH', body: payload, token }),
  deleteItem: (id, token) => request(`/items/${id}`, { method: 'DELETE', token }),

  createBooking: (payload, token) =>
    request('/bookings', { method: 'POST', body: payload, token }),
  getMyBookings: (token) => request('/bookings/mine', { token }),
  cancelBooking: (id, token) => request(`/bookings/${id}/cancel`, { method: 'PATCH', token }),

  getAllBookings: (token, status) =>
    request(`/bookings${status ? `?status=${status}` : ''}`, { token }),
  updateBookingStatus: (id, status, token) =>
    request(`/bookings/${id}/status`, { method: 'PATCH', body: { status }, token }),
};
