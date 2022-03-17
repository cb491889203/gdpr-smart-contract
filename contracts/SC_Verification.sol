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

    DataUsageContract private dc;
    AgreementContract private ac;
    LogContract private lc;

    constructor(address dcAdd, address acAdd, address lcAdd) {
        dc = DataUsageContract(dcAdd);
        ac = AgreementContract(acAdd);
        lc = LogContract(lcAdd);
    }

    uint256[] violets;

    function verify(address actorAddress, address userAddress, uint usageID, string memory serviceName, string memory operation, string[] memory processedData) public returns (uint256){

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
        return violets;
    }

}