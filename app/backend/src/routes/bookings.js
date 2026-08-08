const express = require('express');
const pool = require('../config/db');
const { authenticate, requireRole } = require('../middleware/auth');

const router = express.Router();

// POST /api/bookings - user creates a booking request
router.post('/', authenticate, async (req, res) => {
  const { item_id, note } = req.body;

  if (!item_id) {
    return res.status(400).json({ error: 'item_id is required' });
  }

  try {
    const item = await pool.query('SELECT id, is_active FROM items WHERE id = $1', [item_id]);
    if (item.rows.length === 0 || !item.rows[0].is_active) {
      return res.status(404).json({ error: 'Item not found or unavailable' });
    }

    const result = await pool.query(
      `INSERT INTO bookings (user_id, item_id, note)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [req.user.id, item_id, note || null]
    );

    return res.status(201).json({ booking: result.rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/bookings/mine - user's own bookings
router.get('/mine', authenticate, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT b.*, i.title AS item_title
       FROM bookings b
       JOIN items i ON i.id = b.item_id
       WHERE b.user_id = $1
       ORDER BY b.created_at DESC`,
      [req.user.id]
    );
    return res.json({ bookings: result.rows });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// PATCH /api/bookings/:id/cancel - user cancels own pending booking
router.patch('/:id/cancel', authenticate, async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `UPDATE bookings SET status = 'cancelled', updated_at = now()
       WHERE id = $1 AND user_id = $2 AND status = 'pending'
       RETURNING *`,
      [id, req.user.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found or cannot be cancelled' });
    }
    return res.json({ booking: result.rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/bookings - admin: list all bookings (optional ?status= filter)
router.get('/', authenticate, requireRole('admin'), async (req, res) => {
  const { status } = req.query;
  try {
    const params = [];
    let query = `
      SELECT b.*, i.title AS item_title, u.name AS user_name, u.email AS user_email
      FROM bookings b
      JOIN items i ON i.id = b.item_id
      JOIN users u ON u.id = b.user_id
    `;
    if (status) {
      params.push(status);
      query += ' WHERE b.status = $1';
    }
    query += ' ORDER BY b.created_at DESC';

    const result = await pool.query(query, params);
    return res.json({ bookings: result.rows });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// PATCH /api/bookings/:id/status - admin: approve/reject a booking
router.patch('/:id/status', authenticate, requireRole('admin'), async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!['approved', 'rejected'].includes(status)) {
    return res.status(400).json({ error: "status must be 'approved' or 'rejected'" });
  }

  try {
    const result = await pool.query(
      `UPDATE bookings SET status = $1, updated_at = now()
       WHERE id = $2
       RETURNING *`,
      [status, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    return res.json({ booking: result.rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
