'use strict'

const { test } = require('tap')
const { build } = require('../helper')

test('전체 조회 GET', { timeout: 10000 }, async (t) => {
    const app = await build(t)

    const res = await app.inject({
        method: 'GET',
        url: '/articles'
    })
    t.same(res.statusCode, 200);
    t.equal(res.headers['content-type'], 'application/json; charset=utf-8');
    t.same(JSON.parse(res.payload), [{ id: 1, title: 'Hello', content: 'World' }])

})

// const tap = require('tap')
// const { Client } = require('undici')
// const { build } = require('../helper')

// tap.test('should work with undici', async (t) => {
//     t.plan(2)

//     const fastify = build()

//     await fastify.listen()

//     const client = new Client(
//         'http://localhost:' + fastify.server.address().port, {
//         keepAliveTimeout: 10,
//         keepAliveMaxTimeout: 10
//     }
//     )

//     t.teardown(() => {
//         fastify.close()
//         client.close()
//     })

//     const response = await client.request({ method: 'GET', path: '/articles' })

//     t.same(JSON.parse(res.payload), [{ id: 1, title: 'Hello', content: 'World' }])
//     t.equal(response.statusCode, 200)
// })