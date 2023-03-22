import json
import os
import urllib.request

SLACK_WEBHOOK_URL = os.environ['SLACK_WEBHOOK_URL']
SLACK_CHANNEL = os.environ['SLACK_CHANNEL']

def get_inspirational_quote():
    url = 'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en'
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}
    req = urllib.request.Request(url, headers=headers)
    data = json.loads(urllib.request.urlopen(req).read().decode())
    quote = data['quoteText']
    author = data['quoteAuthor']
    return f"{quote} - {author}"

def lambda_handler(event, context):
    message = get_inspirational_quote()
    data = {
        'text': message,
        'channel': SLACK_CHANNEL,
    }
    headers = {
        'Content-Type': 'application/json',
    }
    req = urllib.request.Request(
      SLACK_WEBHOOK_URL,
      data=json.dumps(data).encode('utf8'),
      headers=headers
    )
    response = urllib.request.urlopen(req)
    return {
        'statusCode': response.getcode(),
        'body': response.read().decode('utf-8')
    }
