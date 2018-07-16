import logging

def handler(event, context):
    logger = logging.getLogger("handler")
    logger.setLevel(logging.INFO)

    return 'hello'
