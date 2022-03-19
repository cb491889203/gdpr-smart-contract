
// constants
const DataUsageContractName = 'DataUsageContract';
const AgreementContractName = 'AgreementContract';
const LogContractName = 'AgreementContract';
const VerificationContractName = 'VerificationContract';

// contract addresses
const DataUsageContractAddress =  '0xC5388D246330E416348C7A272815A99aaeDEBBFc';
const AgreementContractAddress = '0x5945568D6a562934b235019d2E3e1fe63DD45396';
const LogContractAddress = '0xD3e278eDbCef4706A33c411f21ffe9ED62a51a01';
const VerificationContractAddress = '0xB0e310A91F37C13eAC8bcd2836ae109f638dfa22';

// accounts
const userAddress = '0xFD112bb10589F9accfA9FBBdD3d8A27474F23a64';
const actorAddresses = ['0x0d61072103c7A2CfF1d19c6dee972A6F455bF66a','0x384f4B4c2B689EBA5931Cf65b551a0bA92538F12',
'0xD47BfFEde4d644E4be3BEba9dC5F6c2Cf6ad4285','0xF0ccd2822F75d32d468bF396234BcE7F43a501BC',
'0x15778b93f3Cb7DE90d05FE191CFdb4eE7e39aEBf','0xAa09B3ce0AC33E04F446b5B14083580A0135b89E',
'0x610e5A172F44eE5707929B948DBaedC868B8D361','0x487C512B1A406328B29484570fF16c1fE4ea9533',
'0x6E378acC7D7333665ac58B22Db5Bd87De1000439','0xb7009358f4F98E1aC587d45C326079ab5F802936'];
const loggerAddress = '0x70dD9dD3a3D76eF3ffC2Fee69A8c945e49A1A941';
const verifierAddress = '0x18c6B9B766884321bEF25e48A0c6E4d05862A4D8';


(async () => {
    try {
        console.log('Running test script...')
    
        // Note that the script needs the ABI which is generated from the compilation artifact.
        // Make sure contract is compiled and artifacts are generated
        const dataUsageMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${DataUsageContractName}.json`))
        const agreementMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${AgreementContractName}.json`))
        const logMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${LogContractName}.json`))
        const verificationMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${VerificationContractName}.json`))

        let dataUsageContract = new web3.eth.Contract(dataUsageMetadata.abi, DataUsageContractAddress)
        console.log('DataUsageContractAddress : ', dataUsageContract.options.address)
        let agreementContract = new web3.eth.Contract(agreementMetadata.abi, AgreementContractAddress)
        console.log('AgreementContractAddress : ', agreementContract.options.address)
        let logContract = new web3.eth.Contract(logMetadata.abi, LogContractAddress)
        console.log('LogContractAddress : ', logContract.options.address)
        let verificationContract = new web3.eth.Contract(verificationMetadata.abi, VerificationContractAddress)
        console.log('VerificationContractAddress : ', verificationContract.options.address)

        const accounts = await web3.eth.getAccounts()
        console.log('account [0]: ', accounts[0])

        console.log("Start to call useData function ------  ")
        // Send an transaction to DataUsageContract, call the function 'useData'
        
        dataUsageContract.methods.useData(userAddress, 'test', 'test', 'read', ['name', 'gender']).send({
            from: actorAddresses[0]
        }, function(error, transactionHash) {
            console.log('useData send: ', transactionHash);

            // web3.eth.getTransactionReceipt(receiptransactionHashtHash, (error, receipt) => {
            //     console.log(receipt.logs)
            // });
        });

        // web3.eth.getTransactionReceipt("0xd05d3734758ee5e5c2c16daa93a84de5b3bd99a9378e4e4d6aac1d82f97151d7", (error, receipt) => {
        //         console.log(receipt)
        // });

        // dataUsageContract.methods.retrieveDataUsage(5).call().then(console.log)

        dataUsageContract.events.UseData(
            // {
            // filter: {
            //     actorAddress: actorAddresses[0]}
            // }, function(error, event){ 
            //     console.log(event); 
            // }
        )
        .on("connected", function(subscriptionId){
            console.log('events connected', subscriptionId);
        })
        .on('data', function(event){
            console.log("events data: ", event); // same results as the optional callback above
        })
        .on('changed', function(event){
            // remove event from local database
            console.log('events changed', event);
        })
        .on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
            console.log('events error', receipt);
        });




    } catch (e) {
        console.log(e.message)
    }
  })()