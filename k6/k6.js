import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
    vus: 500,
    iterations: 10000,
    stages: [
        { target: 20, duration: '20s' },
        { target: 15, duration: '20s' },
        { target: 0, duration: '20s' },
    ],
    thresholds: {
        http_reqs: ['count <= 200'],
    },
};



export default function () {

    const payload = {
        "title": "test",
        "content": "test"
    };
    const headers = {
        'Content-Type': 'application/json',
        'dataType': 'json',
        'authorization': 'eyJraWQiOiJFUUtVVW1ENXlMXC9INityUGVkRHVNQ3hRamRjeUQ3Qk1VV2hxMnpDRld2WT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJiMzlmYjVkZi0xM2EzLTQ3N2QtOWE5Yi1jM2FjN2JjZDkyYjEiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuYXAtbm9ydGhlYXN0LTIuYW1hem9uYXdzLmNvbVwvYXAtbm9ydGhlYXN0LTJfdGZMQWdWQkZBIiwiY2xpZW50X2lkIjoiM2R2aXRibGZpdXYwZDJxbjltNWprZ282Y3MiLCJvcmlnaW5fanRpIjoiYTczNjVhMTktZGQzNy00MjM4LTk3MmUtMjEwYjFiNmQ5N2IyIiwiZXZlbnRfaWQiOiJmYmFhNWI4Ni0xMDg5LTQ4MDYtYjJmYi1iNjBkODBiMzI4ODgiLCJ0b2tlbl91c2UiOiJhY2Nlc3MiLCJzY29wZSI6ImF3cy5jb2duaXRvLnNpZ25pbi51c2VyLmFkbWluIiwiYXV0aF90aW1lIjoxNjc5NTUwMzc2LCJleHAiOjE2Nzk1NTM5NzYsImlhdCI6MTY3OTU1MDM3NiwianRpIjoiMjQzNmE0NmMtZmY4MS00ZGJhLTkzMmYtM2M4OWRiMjBkYTk2IiwidXNlcm5hbWUiOiJiMzlmYjVkZi0xM2EzLTQ3N2QtOWE5Yi1jM2FjN2JjZDkyYjEifQ.AA0AWrKxogPDGqUsd3bojwzLA8ExGJ8To5nEZyBPBdfUeElGLXv8AeJD8j_fbT1tBgbxYKsdvl6KXb9P5IhBPJBcdr_e96mRmVfdQ9ARewIeo7HPlYvPTA5LYaueHBWJ4IH-bQzt6ORPJ8QaiYD3V8IOGgq_MlRcT_wCHvY-8lJ_sG-G-WyF9cWqXs7E58IgOTjVV2XByMIBlJsL0JbggMsaHB6ehwjy3LRY47ldUeOIgX7ncIqXTTD5Ba4Xde4nlRnYT6PyVwLTkoJEnTGNGAVcVPiapG9lPG0pPn5KNQPnLLp0F2k7O5FgNSzpGwhon0kqvx5KexrHNu50uBQVQw'
    };
    const res = http.request('POST', 'https://api.devops03-gg.click/articles',
        JSON.stringify(payload), {
        headers: headers,
    });
    console.log(JSON.stringify(payload))
    sleep(0.1);

    const checkRes = check(res, {
        'status is 200': (r) => r.status === 200, // 기대한 HTTP 응답코드인지 확인합니다.

    });
}