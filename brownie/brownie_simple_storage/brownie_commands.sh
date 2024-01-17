# 初始化 brownie 项目
brownie init

# 从某个模板项目初始化
brownie bake <project>

# 编译合约
brownie compile

# 部署合约
brownie run scripts/deploy.py
brownie run scripts/deploy.py --network rinkeby
brownie run scripts/deploy.py --network ganache-local
brownie run scripts/deploy.py --network mainnet-fork-dev

# 测试合约
brownie test
brownie test --network rinkeby
brownie test --network ganache-local
brownie test --network mainnet-fork-dev
brownie test -k function_name # 仅测试某个方法
brownie test --pdb # 失败后进入 console
brownie test -s # 带详细测试信息

# 添加账户
brownie accounts new <account>
brownie accounts delete <account>
brownie accounts list

# 添加网络
brownie networks add Ethereum ganache-local host=http://127.0.0.1:8545 chainid=1337
brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork=https://eth-mainnet.alchemyapi.io/v2/P_4AbFr4ragTxd-3h9nq6ml9F0KXLrcr accounts=10 mnemonic=brownie port=8545
brownie networks delete <network>
brownie networks list

# brownie 控制台
brownie console