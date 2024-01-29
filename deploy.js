const ethers = require('ethers')
const fs = require('fs')



async function main(){
    // compile them in our code
    // compile them seperately
    const URL = "http://0.0.0.0:8545"
    const provider = new ethers.providers.JsonRpcProvider(URL)
    const WALLET_SECRET_KEY = '7db.....'
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

    const transactionReceipt = await contract.deployTransaction.wait(1) // this will let u know that the transaction is complete
    console.log(transactionReceipt)

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
}



main()
    .then(()=>process.exit(0))
    .catch((error)=>{
        console.error(error)
        process.exit(1)
    })