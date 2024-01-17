from brownie import SimpleStorage, accounts


def test_deploy():
    # 1. Arrange
    account = accounts[0]
    # 2. Act
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieve()
    expected = 0
    # 3. Assert
    assert starting_value == expected


def test_update_storage():
    # 1. Arrange
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    # 2. Act
    expected = 67
    simple_storage.store(expected, {"from": account})
    # 3. Assert
    assert expected == simple_storage.retrieve()


# tips
# 1. Test specific function: brownie test -k function_name
# 2. Test with python shell if excute error: brownie test --pdb
# 3. Test with more details: brownie test -s
