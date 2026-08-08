import { useEffect, useState } from 'react';
import { api } from '../api/client';
import { useAuth } from '../context/AuthContext';

export default function UserDashboard() {
  const { token, user, logout } = useAuth();
  const [items, setItems] = useState([]);
  const [bookings, setBookings] = useState([]);
  const [note, setNote] = useState('');
  const [selectedItem, setSelectedItem] = useState(null);
  const [error, setError] = useState('');

  async function loadData() {
    try {
      const [itemsRes, bookingsRes] = await Promise.all([
        api.getItems(token),
        api.getMyBookings(token),
      ]);
      setItems(itemsRes.items);
      setBookings(bookingsRes.bookings);
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    loadData();
  }, []);

  async function handleBook(itemId) {
    setError('');
    try {
      await api.createBooking({ item_id: itemId, note }, token);
      setNote('');
      setSelectedItem(null);
      loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleCancel(bookingId) {
    try {
      await api.cancelBooking(bookingId, token);
      loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div className="page">
      <header className="page-header">
        <h1>Welcome, {user?.name}</h1>
        <button onClick={logout}>Logout</button>
      </header>

      {error && <p className="error">{error}</p>}

      <section>
        <h2>Available items</h2>
        <div className="grid">
          {items.map((item) => (
            <div key={item.id} className="card">
              <h3>{item.title}</h3>
              <p>{item.description}</p>
              {selectedItem === item.id ? (
                <div>
                  <input
                    placeholder="Optional note"
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                  />
                  <button onClick={() => handleBook(item.id)}>Confirm booking</button>
                  <button onClick={() => setSelectedItem(null)}>Cancel</button>
                </div>
              ) : (
                <button onClick={() => setSelectedItem(item.id)}>Book</button>
              )}
            </div>
          ))}
          {items.length === 0 && <p>No items available right now.</p>}
        </div>
      </section>

      <section>
        <h2>My bookings</h2>
        <table>
          <thead>
            <tr>
              <th>Item</th>
              <th>Status</th>
              <th>Requested</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {bookings.map((b) => (
              <tr key={b.id}>
                <td>{b.item_title}</td>
                <td className={`status status-${b.status}`}>{b.status}</td>
                <td>{new Date(b.created_at).toLocaleString()}</td>
                <td>
                  {b.status === 'pending' && (
                    <button onClick={() => handleCancel(b.id)}>Cancel</button>
                  )}
                </td>
              </tr>
            ))}
            {bookings.length === 0 && (
              <tr>
                <td colSpan={4}>No bookings yet.</td>
              </tr>
            )}
          </tbody>
        </table>
      </section>
    </div>
  );
}
