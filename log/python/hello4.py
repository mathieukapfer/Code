import logging
import logging.config

logging.config.fileConfig('logging.conf')

def fct1():
    logger = logging.getLogger("fct1")
    logger.warning('Watch out - from fct 1!')  # will print a message to the console
    logger.info('I told you so - from fct 1')  # will not print anything


# root: defaut logger
logging.warning('Watch out!')  # will print a message to the console
logging.info('I told you so')  # will not print anything

fct1()
