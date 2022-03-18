// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./SC_DataUsage.sol";
import "./Lib.sol";

/** 
* Actor use some data of a User Subject, generate the smart contract
 */
contract AgreementContract {

    address private creator;
    address private dataUsageContractAddress;
    DataUsageContract private dataUsageContract;
    mapping(uint => Vote) private votes;

    
    // event for EVM logging
    event UserVote(address indexed userAddress, uint indexed usageID, DataUsage dataUsage, bool consent);
    
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
    function retrieveVote(uint usageID) public view returns (Vote memory) {
        return votes[usageID];
    }

    /**
     * @dev submits a data subject’s votes (positive/negative consent) to the Blockchain
     */
    function vote(uint usageID, bool consent) public {
        
        // Retrieve dataUsage from the DataUsageContract
        DataUsage memory dataUsage = dataUsageContract.retrieveDataUsage(usageID);

        // require (dataUsage.userAddress != address(0x0), "Can't find this data usage record with the usageID");
        // require (msg.sender == dataUsage.userAddress, "The user doesn't belong to this data usage record");
        // require (votes[usageID].userAddress != address(0x0), "User have already vote for this data usage!");

        votes[usageID] = Vote(dataUsage.actorAddress, msg.sender, usageID, consent);

        // Log the user's vote of Agreement contract
        emit UserVote(msg.sender, usageID, dataUsage, consent);
    }
}