const { cognitoIdentityServiceProvider } = require("../../config/auth")
require('dotenv').config()


const clientid = "3dvitblfiuv0d2qn9m5jkgo6cs"
module.exports = async function (fastify, opts) {
    fastify.post('/signup', async function (request, reply) {
        const { email, password, nickname } = request.body
        const params = {
            ClientId: clientid,
            Username: email,
            Password: password,
            UserAttributes: [
                {
                    Name: "email",
                    Value: email
                },
                {
                    Name: "nickname",
                    Value: nickname
                }
            ]
        }
        try {
            const data = await cognitoIdentityServiceProvider.signUp(params).promise()
            reply.code(200).send({ message: "User signde up successfully", data })
        } catch (error) {
            console.error('Failed to sign up user:', error)
            reply.code(400).send({ message: "Failed to sign up user", error })
        }


    })

    fastify.post('/login', async function (request, reply) {
        const { email, password } = request.body
        const params = {
            AuthFlow: "USER_PASSWORD_AUTH",
            ClientId: clientid,
            AuthParameters: {
                USERNAME: email,
                PASSWORD: password
            }
        }
        try {
            const data = await cognitoIdentityServiceProvider.initiateAuth(params).promise()
            const accessToken = data.AuthenticationResult.AccessToken
            reply.code(200).send({ message: "User logged in successfuly", accessToken })
        } catch (error) {
            console.error("Failed to log in user:", error)
            reply.code(400).send({ message: "Failed to log in user", error })
        }
    })



    fastify.post('/verify', async function (request, reply) {
        const { email, verificationCode } = request.body;

        try {
            const params = {
                ClientId: clientid,
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


    fastify.post('/logout', async function (request, reply) {
        const accessToken = request.headers.authorization;
        const params = {
            AccessToken: accessToken,
        };

        try {
            await cognitoIdentityServiceProvider.globalSignOut(params).promise();
            reply.code(200).send({ message: 'User logged out successfully' });
        } catch (error) {
            console.error('Failed to log out user:', error);
            reply.code(400).send({ message: 'Failed to log out user', error });
        }
    });



}