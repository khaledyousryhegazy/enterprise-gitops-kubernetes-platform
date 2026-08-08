require('dotenv').config();
const bcrypt = require('bcryptjs');
const pool = require('../config/db');

async function seedAdmin() {
  const email = process.env.SEED_ADMIN_EMAIL || 'admin@example.com';
  const password = process.env.SEED_ADMIN_PASSWORD || 'Admin@123';
  const name = process.env.SEED_ADMIN_NAME || 'Administrator';

  const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
  if (existing.rows.length > 0) {
    console.log(`Admin user already exists: ${email}`);
    await pool.end();
    return;
  }

  const passwordHash = await bcrypt.hash(password, 10);
  await pool.query(
    'INSERT INTO users (name, email, password_hash, role) VALUES ($1, $2, $3, $4)',
    [name, email, passwordHash, 'admin']
  );

  console.log(`Seeded admin user: ${email} / ${password}`);
  await pool.end();
}

seedAdmin().catch((err) => {
  console.error('Seeding failed:', err.message);
  process.exit(1);
});
