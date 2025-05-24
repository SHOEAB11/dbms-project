const mysql = require('mysql');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'your_username',
    password: 'your_password',
    database: 'management',  
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  });
  