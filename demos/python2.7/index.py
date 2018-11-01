import logging

counter = 0
def initializer(context):
    global counter
    counter += 1

def handler(event, context):
    global counter
    counter += 2
    logger = logging.getLogger("handler")
    logger.setLevel(logging.INFO)
    logger.info('event: ' + event)
    logger.info('context: ' + str(context))

    return counter