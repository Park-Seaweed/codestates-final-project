const AWS = require("aws-sdk")

const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;


AWS.config.update({
    accessKeyId,
    secretAccessKey
})

const region = "ap-northeast-2"
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider({
    region: region
})


async function getUserId(request) {
    const accessToken = request.headers.authorization;

    const params = {
        AccessToken: accessToken
    };

    try {
        const data = await cognitoIdentityServiceProvider.getUser(params).promise();
        const userNickname = data.UserAttributes.find(attr => attr.Name === 'nickname').Value;
        return userNickname;
    } catch (error) {
        return null;
    }
}

module.exports = {
    getUserId,
    cognitoIdentityServiceProvider
}