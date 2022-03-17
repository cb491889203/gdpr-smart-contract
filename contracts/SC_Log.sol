// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./SC_DataUsage.sol";
import "./Lib.sol"

/** 
*   It sends “actor ID”, “operation” and “processed personal data” and “service name” into the Blockchain.
*/
contract LogContract {

    address private creator;
    address private dataUsageContractAddress;
    DataUsageContract private dataUsageContract; 
    // Store all the logs 
    LogContent[] private logs;

    
    // event for EVM logging
    event LogDataProcess(address actorAddress, address userAddress, uint usageID, DataUsage dataUsage);
    
    /**
     * @dev generate a new contract
     */
    constructor(address _dataUsageContractAddress) {
        creator = msg.sender;
        dataUsageContractAddress = _dataUsageContractAddress;
        dataUsageContract = DataUsageContract(dataUsageContractAddress);
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
    function log(address actorAddress, address userAddress, uint usageID) public {
        // Retrieve dataUsage from the DataUsageContract
        DataUsage memory dataUsage = dataUsageContract.retrieveDataUsage(usageID);

        require (dataUsage.userAddress != address(0x0), "Can't find this data usage record with the usageID");
        require (actorAddress == dataUsage.actorAddress, "The actor doesn't belong to this data usage record");
        require (userAddress == dataUsage.userAddress, "The user doesn't belong to this data usage record");

        logs.push(LogContent(actorAddress, userAddress, usageID, dataUsage));

        // Notify user subject
        attestation(actorAddress, userAddress, usageID, dataUsage);
    }

    function attestation(address actorAddress, address userAddress, uint usageID, DataUsage memory dataUsage) internal {
        // send event to User Subject
        emit LogDataProcess(actorAddress, userAddress, usageID, dataUsage);
    }
}