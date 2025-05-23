const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { patient_id, staff_id, activity_type, activity_time, status, feedback } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO activities (patient_id, staff_id, activity_type, activity_time, status, feedback)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [patient_id, staff_id, activity_type, activity_time, status, feedback]);
    res.status(201).json({ message: 'Activity logged', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM activities');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
