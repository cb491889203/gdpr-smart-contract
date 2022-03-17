// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SC_Agreement.sol";
import "./SC_DataUsage.sol";
import "./SC_Log.sol";


/**
 * @title Verifier
 * @dev retrieve value in a vriable
 */
contract VerificationContract {

    address public actor;

    //Flag for verification
    bool public isViolator;

    //address of SmartContracts
    address public dataUsageContractAddress;
    address public agreementContractAddress;
    address public logContractAddress;

    //Data of SmartContracts
    DataUsageContract private dc;
    AgreementContract private ac;
    LogContract private lc;

    struct Verifications {
        address actorId;
    }
    
    // event for EVM logging
    event Verification(address indexed dataUsageContractAddress,address indexed agreementContractAddress, address indexed logContractAddress,
                    address actorId);

    constructor(address dcAdd, address acAdd, address lcAdd) {
        dataUsageContractAddress = dcAdd;
        agreementContractAddress = acAdd;
        logContractAddress = lcAdd;
        dc = DataUsageContract(dcAdd);
        ac = AgreementContract(acAdd);
        lc = LogContract(lcAdd);
    }

    //address violets;

    function verify(address actorAddress, address userAddress, uint usageID, string memory serviceName, string memory operation, string[] memory processedData) public {
/*
        for (uint i=1; i <= logID; i++) {
            address actorID = lc.retrieveLog(i).actorID;
            string operation = lc.retrieveLog(i).operation;
            string[] pd = lc.retrieveLog(i).processedData;

            uint purposeID = 0;

            for(uint i=1; i<=usageID; i++){
                if(dc.retrieveDataUsage[i].actorID == actorID &&
                    dc.retrieveDataUsage[i].operation == operation &&
                    dc.retrieveDataUsage[i].personalData == pd) {
                        purposeID = i;
                        break;
                } else {
                    continue;
                }

                violets.push(actorID);
                actorID = 0;
            }

            for(uint i=1; i<=usageID; i++){
                if(ac.retrieveVote[i].actorID == purposeID && ac.retrieveVote[i].consent == true) {
                    break;
                }
                else{
                    continue;
                }

                violets.push(purposeID);
                thisID = 0;
            }

        }
        */

        //here give value to isViolator according logical judgment above
        isViolator = true;

        deployVerification(isViolator);
    }

    /**
     * @dev check if it is a Violator
     */
    function deployVerification(bool _isViolator) public {
        if (_isViolator){
            actor = msg.sender;
        }
        // send the event
            emit Verification(dataUsageContractAddress,agreementContractAddress,logContractAddress,actor);
            
    }

}