const hre = require("hardhat")

async function main() {
    await hre.run("compile")

    // Deploy the contract
    const SimpleStorage = await hre.ethers.getContractFactory("SimpleStorage")
    const simpleStorage = await SimpleStorage.deploy()
    await simpleStorage.deployed()

    // Call store function
    const transactionResponse = await simpleStorage.store(7)
    const transactionReceipt = await transactionResponse.wait(1)

    // console.log(transactionReceipt)
    console.log("Old Number: ", transactionReceipt.events[0].args.oldNumber.toString())
    console.log("New Number: ", transactionReceipt.events[0].args.newNumber.toString())
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
