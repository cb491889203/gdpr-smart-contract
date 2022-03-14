// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
* Actor use some data of a User Subject, generate the smart contract
 */
contract DataUsageContract {

    address public actorAddress;
    string public actorID;
    string public userID;
    DataUsage private dataUsage;

    
    // event for EVM logging
    event UseData(address indexed actorAddress, string indexed actorID, string indexed userID, DataUsage dataUsage);
    
    /**
     * @dev generate a new contract
     */
    constructor(string memory _actorID, string memory _userID) {
        actorAddress = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        actorID = _actorID;
        userID = _userID;
        dataUsage = DataUsage(_actorID,_userID,_serviceName ,_servicePurpose,_operation ,_personalData);

        // Log the deployment of DataUsage contract
        emit UseData(actorAddress, actorID, userID, dataUsage);
    }

    /**
    *  Using this address, an actor can access the contract and execute function (Gα) based on its purpose of data processing.
    */
    function dataProcess (string memory _serviceName, string memory _servicePurpose, string memory _operation, string[] memory _personalData) public {

    }

    /**
     * @dev get the data usage
     */
    function retrieveDataUsage() public view returns (DataUsage memory){
        return dataUsage;
    }

    /**
     * @dev get the current contract address
     */
    function getContractAddress() public view returns (address) {
        return address(this);
    }
}


struct DataUsage {
    string  actorID;
    string  userID;
    string  serviceName;
    string servicePurpose;
    string  operation;
    string[]  personalData;
}