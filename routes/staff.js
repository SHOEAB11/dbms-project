const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { full_name, role, specialization, contact_info, performance_notes, benefits } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO staff (full_name, role, specialization, contact_info, performance_notes, benefits)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [full_name, role, specialization, JSON.stringify(contact_info), performance_notes, JSON.stringify(benefits)]);
    res.status(201).json({ message: 'Staff added', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM staff');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
