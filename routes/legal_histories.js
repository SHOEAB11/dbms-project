const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { patient_id, incident_type, description, incident_date, reported_by, action_taken } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO legal_histories (patient_id, incident_type, description, incident_date, reported_by, action_taken)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [patient_id, incident_type, description, incident_date, reported_by, action_taken]);
    res.status(201).json({ message: 'Legal history added', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM legal_histories');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
