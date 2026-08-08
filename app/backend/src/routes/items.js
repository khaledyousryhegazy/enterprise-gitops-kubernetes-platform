const express = require('express');
const pool = require('../config/db');
const { authenticate, requireRole } = require('../middleware/auth');

const router = express.Router();

// GET /api/items - list active items (any authenticated user)
router.get('/', authenticate, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, title, description, is_active, created_at FROM items WHERE is_active = true ORDER BY created_at DESC'
    );
    return res.json({ items: result.rows });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/items/all - list all items including inactive (admin only)
router.get('/all', authenticate, requireRole('admin'), async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM items ORDER BY created_at DESC');
    return res.json({ items: result.rows });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/items - create item (admin only)
router.post('/', authenticate, requireRole('admin'), async (req, res) => {
  const { title, description } = req.body;
  if (!title) {
    return res.status(400).json({ error: 'title is required' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO items (title, description) VALUES ($1, $2) RETURNING *',
      [title, description || null]
    );
    return res.status(201).json({ item: result.rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// PATCH /api/items/:id - update item (admin only)
router.patch('/:id', authenticate, requireRole('admin'), async (req, res) => {
  const { id } = req.params;
  const { title, description, is_active } = req.body;

  try {
    const result = await pool.query(
      `UPDATE items SET
         title = COALESCE($1, title),
         description = COALESCE($2, description),
         is_active = COALESCE($3, is_active)
       WHERE id = $4
       RETURNING *`,
      [title, description, is_active, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }
    return res.json({ item: result.rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// DELETE /api/items/:id - delete item (admin only)
router.delete('/:id', authenticate, requireRole('admin'), async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('DELETE FROM items WHERE id = $1 RETURNING id', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }
    return res.json({ message: 'Item deleted' });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
