import logging

logger2 = logging.getLogger(__name__)

logger2.warning('Submodule: Watch out!')  # will print a message to the console
logger2.info('Submodule: I told you so')  # will not print anything
