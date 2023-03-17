'use strict'
const { getUserId } = require("../../config/auth")
const { readerConnection, writerConnection } = require("../../config/mysql")
require('dotenv').config()




module.exports = async function (fastify, opts) {

    fastify.addHook('onRequest', (request, reply, done) => {
        const realClientIp = request.headers['x-forwarded-for'] || request.socket.remoteAddress
        fastify.log.info({ realClientIp }, 'Request received')
        done()
    })


    fastify.post('/', async function (request, reply) {
        const userId = await getUserId(request)
        if (!userId) {
            reply.code(401).send({ message: "Unauthorized" })
            return
        }
        const { title, content } = request.body;
        const [rows, fields] = await writerConnection.execute('INSERT INTO posts (title, content, user_id) VALUES (?, ?, ?)', [title, content, userId]);
        reply.code(201).send({ id: rows.insertId, title, content });
    })

    fastify.get('/', async function (request, reply) {
        const [rows, fields] = await readerConnection.execute('SELECT * FROM posts');
        const posts = rows.map(({ id, title, content, created_at, updated_at }) => ({ id, title, content, created_at, updated_at }));
        reply.code(200).send(posts);
    })

    fastify.get("/:id", async function (request, reply) {
        const { id } = request.params
        const [rows, fields] = await readerConnection.execute('SELECT * FROM posts WHERE id = ?', [id])
        if (rows.length > 0) {
            const { title, content } = rows[0]
            reply.code(200).send({ id, title, content, created_at, updated_at })
        } else {
            reply.code(404).send({ message: 'Post not found' })
        }
    })

    fastify.patch('/:id', async function (request, reply) {
        const userId = await getUserId(request);
        if (!userId) {
            reply.code(401).send({ message: 'Unauthorized' });
            return;
        }

        const { id } = request.params;
        const { title, content } = request.body;
        const [rows, fields] = await writerConnection.execute('UPDATE posts SET title = ?, content = ? WHERE id = ? AND user_id = ?', [title, content, id, userId]);
        if (rows.affectedRows === 0) {
            reply.code(404).send({ message: 'Post not found' });
        } else {
            reply.code(200).send({ id, title, content });
        }
    });

    fastify.delete('/:id', async function (request, reply) {
        const userId = await getUserId(request);
        if (!userId) {
            reply.code(401).send({ message: 'Unauthorized' });
            return;
        }

        const { id } = request.params;
        const [rows, fields] = await writerConnection.execute('DELETE FROM posts WHERE id = ? AND user_id = ?', [id, userId]);
        if (rows.affectedRows === 0) {
            reply.code(404).send({ message: 'Post not found' });
        } else {
            reply.code(200).send({ message: 'Post deleted successfully' });
        }
    });
}
