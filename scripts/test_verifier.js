
// constants
const DataUsageContractName = 'DataUsageContract';
const AgreementContractName = 'AgreementContract';
const LogContractName = 'LogContract';
const VerificationContractName = 'VerificationContract';

// contract addresses
const DataUsageContractAddress =  '0x91A9b8EE12328D9a9D62334Eb3bF5a0e45215Cb1';
const AgreementContractAddress = '0x912bB12D52592389DF6170DB57621aBdBF8F3A63';
const LogContractAddress = '0xe92967d39e5E99995D434ce576434B7F4fa400D8';
const VerificationContractAddress = '0x47806a21FDfC6b3A4Db82c1f8588aD51a1514Ae6';

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

        console.log("Start to listen Log Data Process ------  ")

        // Event listener for log processed data by logger
        logContract.on("LogProcessed", (logID, event) => {
            console.log(`LogProcessed: ${logID}`)
            console.log("LogProcessed event : ", event)

            // Log actual data usage
            verificationContract.connect(provider.getSigner(verifierAddress)).verify(logID).then((value) => {
                console.log('Verifier verify log tx :', value)
            })
        });

        // Event listener for verify result
        console.log("Start to listen Verification ------  ")
        verificationContract.on("Verification", (log, dataUsage, vote, violator, event) => {
            console.log(`Verification: ${ log } - ${ dataUsage } - ${ vote} - ${violator}`)
            console.log("Verification event : ", event)
        });

    } catch (e) {
        console.log(e.message)
    }
  })()
