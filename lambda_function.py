def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from AWS Lambda in a container!"
    }