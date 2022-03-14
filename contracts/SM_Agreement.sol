// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./SM_DataUsage.sol";

/** 
* Actor use some data of a User Subject, generate the smart contract
 */
contract AgreementContract {

    address public actorAddress;
    address public userAddress;
    address public dataUsageContractAddress;
    bool public consent;

    DataUsageContract private dataUsageContract;
    
    // event for deploy this Agreement Contract
    event DeployAgreement(address indexed userAddress, address indexed actorAddress, address indexed dataUsageContractAddress);
    // event for EVM logging
    event UserAgree(address indexed userAddress, address indexed dataUsageContractAddress, string indexed actorID, string userID, bool consent);

    // modifier to check if caller is User
    modifier isUser() {
        require(msg.sender == userAddress, "Caller is not User");
        _;
    }
    
    /**
     * @dev generate a new contract
     */
    constructor(address blockHash, address _dataUsageContractAddress, address _actorAddress) {
        userAddress = msg.sender;
        actorAddress = _actorAddress;
        dataUsageContractAddress = _dataUsageContractAddress; // 'msg.sender' is sender of current call, contract deployer for a constructor
        dataUsageContract = DataUsageContract(dataUsageContractAddress);
        
        // send the event
        emit DeployAgreement(userAddress, actorAddress, dataUsageContractAddress);
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
    function retrieveDataUsage() public view returns (DataUsage memory) {
        return dataUsageContract.retrieveDataUsage();
    }

    /**
     * @dev submits a data subject’s votes (positive/negative consent) to the Blockchain
     */
    function vote(bool _consent) public isUser {
        consent = _consent;

        // Log the user's consent of Agreement contract
        emit UserAgree(userAddress, dataUsageContractAddress, actorID, userID, consent);
    }
}