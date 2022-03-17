// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./Lib.sol";

/** 
* Actor use some data of a User Subject, generate the smart contract
 */
contract DataUsageContract {

    address private creator;
    uint private usageID = 0;
    mapping(uint => DataUsage) private dataUsages;

    
    // event for EVM logging
    event UseData(address indexed actorAddress, address indexed userAddress, uint indexed usageID, DataUsage dataUsage);
    
    /**
     * @dev generate a new contract
     */
    constructor() {
        creator = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
    }

    /**
    *  Using this address, an actor can access the contract and execute function (Gα) based on its purpose of data processing.
    */
    function useData (address userAddress, string memory serviceName, string memory servicePurpose, string memory operation, string[] memory personalData) public returns (uint) {
        address actorAddress = msg.sender;
        DataUsage memory dataUsage = DataUsage(actorAddress, userAddress, serviceName, servicePurpose, operation, personalData);       
        usageID++;
        dataUsages[usageID] = dataUsage;

        // Log the deployment of DataUsage contract
        emit UseData(actorAddress, userAddress, usageID, dataUsage);

        return usageID;
    }

    /**
     * @dev get the data usage
     */
    function retrieveDataUsage(uint _usageID) public view returns (DataUsage memory){
        return dataUsages[_usageID];
    }

    /**
     * @dev get the current contract address
     */
    function getContractAddress() public view returns (address) {
        return address(this);
    }
}

