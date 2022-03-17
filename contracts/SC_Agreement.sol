// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./SC_DataUsage.sol";

/** 
* Actor use some data of a User Subject, generate the smart contract
 */
contract AgreementContract {

    address private creator;
    address private dataUsageContractAddress;
    DataUsageContract private dataUsageContract;

    struct Vote {
        address userAddress;
        uint usageID;
        bool consent;
    }
    
    // event for EVM logging
    event UserVote(address indexed userAddress, address indexed actorAddress, uint indexed usageID, DataUsage dataUsage, bool consent);
    
    /**
     * @dev generate a new contract
     */
    constructor(address _dataUsageContractAddress) {
        creator = msg.sender;
        dataUsageContractAddress = _dataUsageContractAddress; // 'msg.sender' is sender of current call, contract deployer for a constructor
        dataUsageContract = DataUsageContract(dataUsageContractAddress);
    }

    /**
     * @dev get the current contract address
     */
    function getContractAddress() public view returns (address) {
        return address(this);
    }

    /**
     * @dev The Retrieve function uses the address of a GDPR compliance contract to provide a data subject information recorded by an actor in the Blockchain
     */
    function retrieveDataUsage(uint usageID) public view returns (DataUsage memory) {
        return dataUsageContract.retrieveDataUsage(usageID);
    }

    /**
     * @dev submits a data subject’s votes (positive/negative consent) to the Blockchain
     */
    function vote(uint usageID, bool consent) public {
        
        // Retrieve dataUsage from the DataUsageContract
        DataUsage memory dataUsage = dataUsageContract.retrieveDataUsage(usageID);

        require (dataUsage.userAddress != address(0x0), "Can't find this data usage record with the usageID");
        require (msg.sender == dataUsage.userAddress, "The user doesn't belong to this data usage record");

        // Log the user's vote of Agreement contract
        emit UserVote(msg.sender, dataUsage.actorAddress, usageID, dataUsage, consent);
    }
}