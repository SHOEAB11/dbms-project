const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/', async (req, res) => {
  const { item_name, item_type, patient_id, stock_level, expiry_date, document_path, item_details, vendor_info, status } = req.body;
  try {
    const [result] = await db.query(`
      INSERT INTO inventory (item_name, item_type, patient_id, stock_level, expiry_date,
        document_path, item_details, vendor_info, status)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [item_name, item_type, patient_id, stock_level, expiry_date, document_path,
        JSON.stringify(item_details), JSON.stringify(vendor_info), status]);
    res.status(201).json({ message: 'Item added', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM inventory');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

module.exports = router;
