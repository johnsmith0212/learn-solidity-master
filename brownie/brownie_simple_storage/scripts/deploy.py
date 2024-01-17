import os
from brownie import network, accounts, config, SimpleStorage

# brownie console


def deploy_simple_storage():

    account = get_account()
    print(account)

    # Deploy the SimpleStorage contract
    print("Deploying contract...")
    simple_storage = SimpleStorage.deploy({"from": account})
    print("Deployed!")

    # Call: retrieve function
    store_value = simple_storage.retrieve()
    print(store_value)

    # Transaction: store function
    transaction = simple_storage.store(67, {"from": account})
    transaction.wait(1)

    # See updated value
    updated_store_value = simple_storage.retrieve()
    print(updated_store_value)


def get_account():
    if network.show_active() == "development":
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


def main():
    print("Running deploy script...")
    deploy_simple_storage()
    print("Successfully execute deploy scripts!")
