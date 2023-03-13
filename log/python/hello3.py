import logging

def fct1():
    logger = logging.getLogger("fct1")
    logger.warning('Watch out - from fct 1!')  # will print a message to the console
    logger.info('I told you so - from fct 1')  # will not print anything


def fct2():
    logger = logging.getLogger("fct2")
    logger.warning('Watch out - from fct 2!')  # will print a message to the console
    logger.info('I told you so - from fct 2')  # will not print anything


# root: defaut logger
logging.warning('Watch out!')  # will print a message to the console
logging.info('I told you so')  # will not print anything

fct1()
fct2()
