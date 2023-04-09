#!/usr/bin/python3
"""
Fabric script that deletes out-of-date archives.
"""

from fabric.api import *
from os import path

env.hosts = ['<IP web-01>', '<IP web-02>']
env.user = '<username>'
env.key_filename = '~/.ssh/id_rsa'


def do_clean(number=0):
    """
    Deletes all unnecessary archives from the versions and releases folders.

    Args:
        number (int): The number of archives to keep (including the most recent).
            If number is 0 or 1, keep only the most recent version of the archive.
            If number is 2, keep the most recent and second most recent versions
            of the archive, and so on.
    """
    number = int(number)
    if number < 0:
        return

    with lcd("./versions"):
        local("ls -t | tail -n +{} | xargs -I {{}} rm -- {{}}".format(
            number + 1))

    with cd("/data/web_static/releases"):
        run("ls -t | tail -n +{} | xargs -I {{}} rm -rf -- {{}}".format(
            number + 1))

