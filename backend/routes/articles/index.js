'use strict'

const mysql = require('mysql2/promise');
require('dotenv').config()

const writerConnection = mysql.createPool({
    host: process.env.HOSTNAME,
    user: process.env.USERNAME,
    password: process.env.PASSWORD,
    database: process.env.DATABASE
});

const readerConnection = mysql.createPool({
    host: process.env.READ_HOSTNAME,
    user: process.env.USERNAME,
    password: process.env.PASSWORD,
    database: process.env.DATABASE
})

module.exports = async function (fastify, opts) {

    fastify.addHook('onRequest', (request, reply, done) => {
        const realClientIp = request.headers['x-forwarded-for'] || request.socket.remoteAddress
        fastify.log.info({ realClientIp }, 'Request received')
        done()
    })

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

    fastify.get("/:id", async function (request, reply) {
        const { id } = request.params
        const [rows, fields] = await readerConnection.execute('SELECT * FROM posts WHERE id = ?', [id])
        if (rows.length > 0) {
            const { title, content } = rows[0]
            reply.code(200).send({ id, title, content })
        } else {
            reply.code(404).send({ message: 'Post not found' })
        }
    })

    fastify.put('/:id', async function (request, reply) {
        const { id } = request.params;
        const { title, content } = request.body;
        const [rows, fields] = await writerConnection.execute('UPDATE posts SET title = ?, content = ? WHERE id = ?', [title, content, id]);
        if (rows.affectedRows === 0) {
            reply.code(404).send({ message: 'Post not found' });
        } else {
            reply.code(200).send({ id, title, content });
        }
    });

    fastify.delete('/:id', async function (request, reply) {
        const { id } = request.params;
        const [rows, fields] = await writerConnection.execute('DELETE FROM posts WHERE id = ?', [id]);
        if (rows.affectedRows === 0) {
            reply.code(404).send({ message: 'Post not found' });
        } else {
            reply.code(200).send({ message: 'Post deleted successfully' });
        }
    });
}