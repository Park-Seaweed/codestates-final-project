'use strict'


const mysql = require('mysql2/promise');
require('dotenv').config()

const writerConnection = mysql.createPool({
    host: process.env.HOSTNAME,
    user: process.env.USERNAME,
    password: process.env.PASSWORD,
    database: process.env.DATABASE
});





module.exports = async function (fastify, opts) {




    fastify.post('/', async function (request, reply) {
        const { title, content } = request.body;
        const [rows, fields] = await writerConnection.execute('INSERT INTO posts (title, content) VALUES (?, ?)', [title, content]);
        reply.code(201).send({ id: rows.insertId, title, content });
    })

    fastify.get('/', async function (request, reply) {
        const [rows, fields] = await readerConnection.execute('SELECT * FROM posts');
        const posts = rows.map(({ id, title, content }) => ({ id, title, content }));
        reply.code(200).send(posts);
    })

}