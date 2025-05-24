const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Routes
app.use('/staff', require('./routes/staff'));
const patientsRouter = require('./routes/patients');
app.use('/rehab_programs', require('./routes/rehab_programs'));
app.use('/appointments', require('./routes/appointments'));
app.use('/activities', require('./routes/activities'));
app.use('/health_logs', require('./routes/health_logs'));
app.use('/inventory', require('./routes/inventory'));
app.use('/admin_logs', require('./routes/admin_logs'));
app.use('/legal_histories', require('./routes/legal_histories'));

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
