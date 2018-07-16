import logging

def handler(event, context):
    logger = logging.getLogger("handler")
    logger.setLevel(logging.INFO)
    logger.info('event: ' + event)
    logger.info('context: ' + str(context))

    return 'hello'