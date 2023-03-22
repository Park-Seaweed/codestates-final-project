'use strict';

const fp = require('fastify-plugin');

module.exports = fp(async function (fastify, opts) {
    fastify.register(require('@fastify/cors'),{
        origin: 'https://www.devops03-gg.click/*'
    });
});