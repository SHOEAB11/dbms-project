const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { patient_id, staff_id, log_type, data } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO health_logs (patient_id, staff_id, log_type, data)
      VALUES (?, ?, ?, ?)`,
      [patient_id, staff_id, log_type, JSON.stringify(data)]);
    res.status(201).json({ message: 'Health log added', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM health_logs');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
