// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./SC_DataUsage.sol";
import "./SC_Verification.sol";
import "./SC_Agreement.sol";
import "./Lib.sol";

/** 
*   It sends “actor ID”, “operation” and “processed personal data” and “service name” into the Blockchain.
*/
contract LogContract {

    address private creator;
    address private dataUsageContractAddress;
    address private agreementContractAddress;
    DataUsageContract private dataUsageContract; 
    AgreementContract private agreementContract;
    // Store all the logs 
    mapping(uint => LogContent) private logs;

    
    // event for EVM logging
    event LogDataProcess(address actorAddress, address userAddress, uint usageID, string serviceName, string operation, string[] processedData);
    
    /**
     * @dev generate a new contract
     */
    constructor(address _dataUsageContractAddress, address _agreementContractAddress) {
        creator = msg.sender;
        dataUsageContractAddress = _dataUsageContractAddress;
        agreementContractAddress = _agreementContractAddress;
        dataUsageContract = DataUsageContract(dataUsageContractAddress);
        agreementContract = AgreementContract(agreementContractAddress);
    }

    /**
     * @dev get the current contract address
     */
    function getContractAddress() public view returns (address) {
        return address(this);
    }

    /**
     * @dev This function collects information about operations carried out in the container, thereby supporting a subset of the data usage relation set P0 ⊆ P
     *  described in Def. 2, and submits it into the Blockchain. Such
     *  information includes the address of the actor (cloud provider)
     *  act involved, the executed operation α, and the data d that has been processed. T
     */
    function log(address actorAddress, address userAddress, uint usageID, string memory serviceName, string memory operation, string[] memory processedData) public {

        logs[usageID] = LogContent(actorAddress, userAddress, usageID, serviceName, operation, processedData);

        // Notify user subject
        attestation(actorAddress, userAddress, usageID, serviceName, operation, processedData);

    }

    function attestation(address actorAddress, address userAddress, uint usageID, string memory serviceName, string memory operation, string[] memory processedData) internal {
        // send event to User Subject
        emit LogDataProcess(actorAddress, userAddress, usageID, serviceName, operation, processedData);

        // Call verification contract verify() to check the violation
        VerificationContract verificationContract = VerificationContract(dataUsageContractAddress, agreementContractAddress, address(this));
        verificationContract.verify(actorAddress, userAddress, usageID, serviceName, operation, processedData);
    }

    function retrieveLog(uint usageID) public returns (LogContent memory) {
        return logs[usageID];
    }
}