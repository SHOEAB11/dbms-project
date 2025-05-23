const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { program_name, description, program_type, start_date, end_date, created_by } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO rehab_programs (program_name, description, program_type, start_date, end_date, created_by)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [program_name, description, program_type, start_date, end_date, created_by]);
    res.status(201).json({ message: 'Program created', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM rehab_programs');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
