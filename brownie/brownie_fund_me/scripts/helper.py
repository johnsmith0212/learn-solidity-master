from brownie import network, config, accounts, MockV3Aggregator
from web3 import Web3

DECIMAL = 8
STARTING_PRICE = 200000000000
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]
FORKED_LOCAL_ENVIRONMENT = ["mainnet-fork", "mainnet-fork-dev"]


def get_account():
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENT
        # brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork='https://mainnet.infura.io/v3/$WEB3_INFURA_PROJECT_ID
    ):
        # 1. With local ganache accounts
        # brownie run scripts/deploy.py
        return accounts[0]
    else:
        # brownie run scripts/deploy.py --network rinkeby
        # 2. With accounts generated using commandline
        # brownie accounts new xxx
        # brownie accounts delete xxx
        # brownie accounts list

        # return accounts.load("pseudoyu")

        # 3. With environment variables
        # return os.getenv("PRIVATE_KEY")

        # 4. With brownie-config.yaml
        return accounts.add(config["wallets"]["from_key"])


def deploy_mocks():
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(
            DECIMAL, Web3.toWei(2000, "ether"), {"from": get_account()}
        )
