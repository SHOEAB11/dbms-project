const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { patient_id, staff_id, appointment_type, scheduled_time, status, notes } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO appointments (patient_id, staff_id, appointment_type, scheduled_time, status, notes)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [patient_id, staff_id, appointment_type, scheduled_time, status, notes]);
    res.status(201).json({ message: 'Appointment created', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM appointments');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
