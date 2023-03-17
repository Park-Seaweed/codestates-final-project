const AWS = require("aws-sdk")

const region = "ap-northeast-2"
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider({
    region: region
})


async function getUserId(request) {
    const accessToken = request.headers.authorization
    const params = {
        AccessToken: accessToken
    }

    try {
        const response = await cognitoIdentityServiceProvider.getUser(params).promise()
        return response.Username
    } catch (error) {
        console.error('Failed to get user from Cognito:', error)
        return null
    }
}

module.exports = {
    getUserId,
    cognitoIdentityServiceProvider
}