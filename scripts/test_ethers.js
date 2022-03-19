
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
    
        // 'web3Provider' is a remix global variable object
        const provider = new ethers.providers.Web3Provider(web3Provider)
        const signer = provider.getSigner()
        // let factory = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);

        const dataUsageMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${DataUsageContractName}.json`))
        const agreementMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${AgreementContractName}.json`))
        const logMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${LogContractName}.json`))
        const verificationMetadata = JSON.parse(await remix.call('fileManager', 'getFile', `browser/contracts/artifacts/${VerificationContractName}.json`))

        let dataUsageContract = new ethers.Contract(DataUsageContractAddress, dataUsageMetadata.abi, provider);
        console.log('DataUsageContractAddress : ', dataUsageContract.address)
        let agreementContract = new ethers.Contract(AgreementContractAddress, agreementMetadata.abi, provider);
        console.log('AgreementContractAddress : ', agreementContract.address)
        let logContract = new ethers.Contract(LogContractAddress, logMetadata.abi, provider);
        console.log('LogContractAddress : ', logContract.address)
        let verificationContract = new ethers.Contract(VerificationContractAddress, verificationMetadata.abi, provider);
        console.log('VerificationContractAddress : ', verificationContract.address)


        console.log("Start to call useData function ------  ")
        // Send an transaction to DataUsageContract, call the function 'useData'
        
        // dataUsageContract.methods.useData(userAddress, 'test', 'test', 'read', ['name', 'gender']).send({
        //     from: actorAddresses[0]
        // }, function(error, transactionHash) {
        //     console.log('useData send: ', transactionHash);

        //     // web3.eth.getTransactionReceipt(receiptransactionHashtHash, (error, receipt) => {
        //     //     console.log(receipt.logs)
        //     // });
        // });

        const daiWithSigner = dataUsageContract.connect(provider.getSigner(actorAddresses[0]));
        let result = await daiWithSigner.retrieveDataUsage(5)
        console.log('retrieveDataUsage = ', result)

        console.log('Actor use data ----- ')
        daiWithSigner.useData(userAddress, 'test', 'test', 'read', ["name"]).then((value) => {
            console.log('Actor use data tx :', value)
        })

        // Event listener for UseData by actor
        dataUsageContract.on("UseData", (_actorAddress, _userAddress, _usageID, _dataUsage, event) => {
            console.log(`UseData: ${ _actorAddress } use ${ _userAddress }'s data ${ _dataUsage} with the usageID ${_usageID}`)
            console.log("UseData event : ", event)

            // User vote for this DataUsage:
            userVote(agreementContract, provider, _userAddress, _usageID, true)
        });

        // Event listener for UserVote by user
        agreementContract.on("UserVote", (userAddress, usageID, dataUsage, consent, event) => {
            console.log(`UserVote: ${ userAddress } vote ${ usageID }:  ${ consent} with the dataUsage: ${dataUsage}`)
            console.log("UserVote event : ", event)
        });

    } catch (e) {
        console.log(e.message)
    }
  })()


async function userVote(agreementContract, provider, userAddress, usageID, vote) {
    
    let result = await agreementContract.connect(provider.getSigner(userAddress)).retrieveVote(10)
    console.log('retrieveVote result = ', result)

    agreementContract.connect(provider.getSigner(userAddress)).vote(usageID, vote).then((value) => {
        console.log('user Vote tx :', value)
    })

}