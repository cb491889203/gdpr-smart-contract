// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
* Actor use some data of a User Subject, generate the smart contract
 */
contract LogContract {

    address public actorAddress;
    address public dataUsageContractAddress;
    string public actorID;
    string public userID;
    bool public consent;

    // modifier to check if caller is Actor
    modifier isActor() {
        require(msg.sender == actorAddress, "Caller is not Actor");
        _;
    }
    
    // event for EVM logging
    event UsserAgree(address indexed userAddress, address indexed dataUsageContractAddress, string indexed actorID, string userID, bool consent);
    
    /**
     * @dev generate a new contract
     */
    constructor(address _dataUsageContractAddress, string memory _actorID, string memory _userID, bool _consent) {
        userAddress = msg.sender;
        dataUsageContractAddress = _dataUsageContractAddress; // 'msg.sender' is sender of current call, contract deployer for a constructor
        actorID = _actorID;
        userID = _userID;
        consent = _consent;

        // Log the deployment of Agreement contract
        emit UsserAgree(userAddress, dataUsageContractAddress, actorID, userID, consent);
    }

    /**
     * @dev get the current contract address
     */
    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function log() public isActor {

    }
}