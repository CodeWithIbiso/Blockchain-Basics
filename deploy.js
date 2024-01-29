const ethers = require('ethers')
const fs = require('fs')
require('dotenv').config


async function main(){
    // compile them in our code
    // compile them seperately
    const URL = process.env.RPC_URL
    const provider = new ethers.providers.JsonRpcProvider(URL)
    const WALLET_SECRET_KEY = process.env.PRIVATE_KEY
    const wallet = new ethers.Wallet(
        WALLET_SECRET_KEY,
        provider
    )
    // in order to deploy our contract we will need the ABI and the binary 
    const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8")
    const binary = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.bin", "utf8")

    // contract factory is just an object that u use to deploy contracts
    const contractFactory = new ethers.ContractFactory(abi, binary, wallet)
    console.log("Deploying, please wait...")

    const contract = await contractFactory.deploy() // we can add gasPrice etc to our deploy call
    console.log(contract)  // now you will get confirmation that transaction has been made

    const transactionReceipt = await contract.deployTransaction.wait(1) // this will let u know that the transaction is complete cause itll wait one block (one new block?)
    console.log(transactionReceipt)
    {/*
        // Lets deploy with transaction data only rather than the process above
        const nonce = await wallet.getTransactionCount()
        const tx = {
            nonce : nonce,
            gasPrice : 2000000,
            gasLimit : 100000,
            to : null,
            value : 0,
            // data is bin data prefixed by 0x
            data : "0x608060405234801561000f575f80fd5b50610...",
            chainId : 1337
        }
        // const signedTxResponse = await wallet.signTransaction(tx) // if you just want to sign
        const sentTxResponse = await wallet.sendTransaction(tx)  
        await sentTxResponse.wait(1)
        console.log(sentTxResponse) // this and transactionReceipt will return the same thing 

    */}
    // lets call functions in our contract
    const currentFavoriteNumber = await contract.retrieve()
    console.log(currentFavoriteNumber)
    console.log("Current favorite number is: ",currentFavoriteNumber.string()) // makes it readable

    const transactionResponse = await contract.store("7") // either 7 or "7" will work but its advisable to use "7" so js can handle it properly
    const transactionReceipt2 = await transactionReceipt.wait(1) // am thinking this is wait till the block is added. till one block is added

    const updatedFavoriteNumber = await contract.retrieve()
    console.log("Updated favorite number is: ",updatedFavoriteNumber.string())  
}



main()
    .then(()=>process.exit(0))// This line of code terminates the Node.js process with an exit code of 0, indicating successful execution
    .catch((error)=>{
        console.error(error)
        process.exit(1) // This line of code terminates the Node.js process with an exit code of 1, indicating that the program encountered an error or failed to execute successfully
    })