const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { staff_id, log_type, description, log_data } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO admin_logs (staff_id, log_type, description, log_data)
      VALUES (?, ?, ?, ?)`,
      [staff_id, log_type, description, JSON.stringify(log_data)]);
    res.status(201).json({ message: 'Admin log recorded', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM admin_logs');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
