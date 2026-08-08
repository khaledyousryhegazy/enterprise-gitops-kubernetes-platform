import { useEffect, useState } from 'react';
import { api } from '../api/client';
import { useAuth } from '../context/AuthContext';

export default function AdminDashboard() {
  const { token, user, logout } = useAuth();
  const [bookings, setBookings] = useState([]);
  const [items, setItems] = useState([]);
  const [statusFilter, setStatusFilter] = useState('');
  const [newItem, setNewItem] = useState({ title: '', description: '' });
  const [error, setError] = useState('');

  async function loadData() {
    try {
      const [bookingsRes, itemsRes] = await Promise.all([
        api.getAllBookings(token, statusFilter || undefined),
        api.getAllItems(token),
      ]);
      setBookings(bookingsRes.bookings);
      setItems(itemsRes.items);
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    loadData();
  }, [statusFilter]);

  async function handleDecision(id, status) {
    try {
      await api.updateBookingStatus(id, status, token);
      loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleCreateItem(e) {
    e.preventDefault();
    try {
      await api.createItem(newItem, token);
      setNewItem({ title: '', description: '' });
      loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleToggleItem(item) {
    try {
      await api.updateItem(item.id, { is_active: !item.is_active }, token);
      loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div className="page">
      <header className="page-header">
        <h1>Admin — {user?.name}</h1>
        <button onClick={logout}>Logout</button>
      </header>

      {error && <p className="error">{error}</p>}

      <section>
        <h2>Bookings</h2>
        <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
          <option value="">All statuses</option>
          <option value="pending">Pending</option>
          <option value="approved">Approved</option>
          <option value="rejected">Rejected</option>
          <option value="cancelled">Cancelled</option>
        </select>

        <table>
          <thead>
            <tr>
              <th>User</th>
              <th>Item</th>
              <th>Status</th>
              <th>Note</th>
              <th>Requested</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {bookings.map((b) => (
              <tr key={b.id}>
                <td>
                  {b.user_name} ({b.user_email})
                </td>
                <td>{b.item_title}</td>
                <td className={`status status-${b.status}`}>{b.status}</td>
                <td>{b.note || '-'}</td>
                <td>{new Date(b.created_at).toLocaleString()}</td>
                <td>
                  {b.status === 'pending' && (
                    <>
                      <button onClick={() => handleDecision(b.id, 'approved')}>Accept</button>
                      <button onClick={() => handleDecision(b.id, 'rejected')}>Reject</button>
                    </>
                  )}
                </td>
              </tr>
            ))}
            {bookings.length === 0 && (
              <tr>
                <td colSpan={6}>No bookings found.</td>
              </tr>
            )}
          </tbody>
        </table>
      </section>

      <section>
        <h2>Manage items</h2>
        <form onSubmit={handleCreateItem} className="inline-form">
          <input
            placeholder="Title"
            value={newItem.title}
            onChange={(e) => setNewItem({ ...newItem, title: e.target.value })}
            required
          />
          <input
            placeholder="Description"
            value={newItem.description}
            onChange={(e) => setNewItem({ ...newItem, description: e.target.value })}
          />
          <button type="submit">Add item</button>
        </form>

        <table>
          <thead>
            <tr>
              <th>Title</th>
              <th>Description</th>
              <th>Active</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <tr key={item.id}>
                <td>{item.title}</td>
                <td>{item.description}</td>
                <td>{item.is_active ? 'Yes' : 'No'}</td>
                <td>
                  <button onClick={() => handleToggleItem(item)}>
                    {item.is_active ? 'Deactivate' : 'Activate'}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </div>
  );
}
