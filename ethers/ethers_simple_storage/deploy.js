const ethers = require("ethers")
const fs = require("fs-extra")
require("dotenv").config()

async function main() {
    const provider = new ethers.providers.JsonRpcProvider(
        process.env.RINKEBY_RPC_URL
    )
    const wallet = new ethers.Wallet(process.env.RINKEBY_PRIVATE_KEY, provider)

    // const encryptedJson = fs.readFileSync("./.encryptedKey.json", "utf8");
    // let wallet = new ethers.Wallet.fromEncryptedJsonSync(encryptedJson, process.env.PRIVATE_KEY_PASSWORD);
    // wallet = await wallet.connect(provider);

    const abi = fs.readFileSync(
        "./SimpleStorage_sol_SimpleStorage.abi",
        "utf-8"
    )
    const binary = fs.readFileSync(
        "./SimpleStorage_sol_SimpleStorage.bin",
        "utf-8"
    )

    const contractFactory = new ethers.ContractFactory(abi, binary, wallet)
    console.log("Deploying contract, please wait...")
    const contract = await contractFactory.deploy()
    await contract.deployTransaction.wait(1)
    console.log("Contract deployed at:", contract.address)
    // const transactionReceipt = await contract.deployTransaction.wait(1);
    // console.log("Transaction receipt:", transactionReceipt);

    // console.log("Let's deploy with only transaction data!");
    // const nonce = await wallet.getTransactionCount();
    // const tx = {
    //     nonce: nonce,
    //     gasPrice: 20000000000,
    //     gasLimit: 1000000,
    //     to: null,
    //     value: 0,
    //     data: "0x" + binary,
    //     chainId: 1337,
    // };

    // const signedTx = await wallet.signTransaction(tx);
    // console.log("Signed transaction:", signedTx);

    // const sentTxResponse = await wallet.sendTransaction(tx);
    // await sentTxResponse.wait(1);
    // console.log("Transaction receipt:", sentTxResponse);

    const currentFavoriteNumber = await contract.retrieve()
    console.log(`Current favorite number: ${currentFavoriteNumber.toString()}`)

    const transactionResponse = await contract.store("7")
    const transactionReceipt = await transactionResponse.wait(1)
    // console.log("Transaction receipt:", transactionReceipt);

    const updatedFavoriteNumber = await contract.retrieve()
    console.log(`Updated favorite number: ${updatedFavoriteNumber.toString()}`)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log("Error: " + error)
        process.exit(1)
    })
