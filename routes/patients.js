const express = require("express");
const router = express.Router();
const db = require("../db");

// POST /patients — Register new patient
router.post("/", (req, res) => {
  const {
    full_name,
    age,
    gender,
    admission_date,
    room_no,
    legal_status,
    is_asylum
  } = req.body;

  const sql = `
    INSERT INTO patients (full_name, age, gender, admission_date, room_no, legal_status, is_asylum)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;
  db.query(
    sql,
    [full_name, age, gender, admission_date, room_no, legal_status, is_asylum],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({ message: "Patient registered", id: result.insertId });
    }
  );
});

module.exports = router;
