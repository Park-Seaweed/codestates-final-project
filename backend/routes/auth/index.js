const { cognitoIdentityServiceProvider } = require("../../config/auth")
module.exports = async function (fastify, opts) {
    fastify.post('/signup', async function (request, reply) {
        const { email, password } = request.body
        const params = {
            ClientId: "411dlu4ni2fr31igv4dm0am5id",
            Username: email,
            Password: password,
            UserAttributes: [
                {
                    Name: "email",
                    Value: email
                }
            ]
        }
        try {
            const data = await cognitoIdentityServiceProvider.signUp(params).promise()
            reply.code(200).send({ message: "User signde up successfully", data })
        } catch (error) {
            console.error('Failed to sign up user:', error)
            reply.code(200).send({ message: "Failed to sign up user", error })
        }


    })

    fastify.post('/verify', async function (request, reply) {
        const { email, verificationCode } = request.body;

        try {
            const params = {
                ClientId: "411dlu4ni2fr31igv4dm0am5id",
                ConfirmationCode: verificationCode,
                Username: email,
            };

            const data = await cognitoIdentityServiceProvider.confirmSignUp(params).promise()

            reply.code(200).send({ message: 'User verified successfully', data });
        } catch (error) {
            console.error('Failed to verify user', error);
            reply.code(500).send({ message: 'Failed to verify user', error });
        }
    });


    // fastify.post('/login', async function (request, reply){
    //     cons
    // })
}