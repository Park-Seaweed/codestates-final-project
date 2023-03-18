const mysql = require('mysql2/promise');
require('dotenv').config()

// const writerConnection = mysql.createPool({
//     host: process.env.WRITE_HOSTNAME,
//     user: process.env.USERNAME,
//     password: process.env.PASSWORD,
//     database: process.env.DATABASE
// });

// const readerConnection = mysql.createPool({
//     host: process.env.READ_HOSTNAME,
//     user: process.env.USERNAME,
//     password: process.env.PASSWORD,
//     database: process.env.DATABASE
// })

// module.exports = {
//     writerConnection,
//     readerConnection
// }
const testConnection = mysql.createPool({
    host: "database-1.chjugwvoqrj2.ap-northeast-2.rds.amazonaws.com",
    user: "admin",
    password: "p2k2p2k2",
    database: "test"
})

module.exports = {
    testConnection
}