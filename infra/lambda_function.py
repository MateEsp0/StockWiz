import datetime

def lambda_handler(event, context):
    now = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    message = f"✅ StockWiz Lambda ejecutada correctamente a las {now} UTC"
    print(message)
    return {
        'statusCode': 200,
        'body': message
    }
