from lib2to3.pgen2.literals import simple_escapes
from brownie import config, accounts, SimpleStorage


def read_contract():
    simple_storage = SimpleStorage[-1]
    print(simple_storage.retrieve())


def main():
    read_contract()
