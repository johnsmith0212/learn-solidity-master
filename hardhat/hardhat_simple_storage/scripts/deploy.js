// 导入包
const { ethers, run, network } = require("hardhat")

// main 方法
async function main() {
    const SimpleStorageFactory = await ethers.getContractFactory(
        "SimpleStorage"
    )
    console.log("Deploying SimpleStorage Contract...")
    const simpleStorage = await SimpleStorageFactory.deploy()
    await simpleStorage.deployed()
    console.log("SimpleStorage Contract deployed at:", simpleStorage.address)

    if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
        await simpleStorage.deployTransaction.wait(6)
        await verify(simpleStorage.address, [])
    }

    // 获取当前值
    const currentValue = await simpleStorage.retrieve()
    console.log("Current value:", currentValue)

    // 设置值
    const transactionResponse = await simpleStorage.store(7)
    await transactionResponse.wait(1)

    // 获取更新后的值
    const updatedValue = await await simpleStorage.retrieve()
    console.log("Updated value:", updatedValue)
}

// verify 合约方法
async function verify(contractAddress, args) {
    console.log("Verifying SimpleStorage Contract...")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguements: args,
        })
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified!")) {
            console.log("Already Verified!")
        } else {
            console.log(e)
        }
    }
}

// 执行 main 方法
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
