import boto3
import json
import logging
import os
import time

from datetime import datetime, timedelta
from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

HOOK_URL = os.environ['HOOK_URL']
SLACK_CHANNEL = os.environ['SLACK_CHANNEL']

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def convert_kst(utc_string):
	dt_tm_utc = datetime.strptime(utc_string, '%Y-%m-%dT%H:%M:%S.%f%z')
	tm_kst = dt_tm_utc + timedelta(hours=9)
	str_datetime = tm_kst.strftime('%Y-%m-%dT%H:%M:%S.%f%z')
	
	return str_datetime

def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    message = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(message))

    alarm_name = message['AlarmName']
    metric_name = message['Trigger']['MetricName']
    threshold = message['Trigger']['Threshold']
    comparison_operator = message['Trigger']['ComparisonOperator']
    period = message['Trigger']['Period']
    evaluation_periods = message['Trigger']['EvaluationPeriods']
    current_state = message['NewStateValue']
    reason = message['NewStateReason']
    timestamp = convert_kst(message['StateChangeTime'])

    slack_message = {
        'channel': SLACK_CHANNEL,
        'text': f'Auto Scaling 그룹 {alarm_name} 에서 경보를 트리거했습니다.\n\n*Details:*\n- 경보 이름: {alarm_name}\n- 지표 이름: {metric_name}\n- 임계값: {threshold}%\n- 연산자: {comparison_operator}\n- 평가 기간: {period}s\n- 기준을 위반하는 데이터포인트 수: {evaluation_periods}\n- 경보 발생 이 이유: {reason}\n- 현재 상태: {current_state}\n- 경보 발생 시간: {timestamp}\n\n'
    }

    req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)

