// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SC_Agreement.sol";
import "./SC_DataUsage.sol";
// import "./Lib.sol";

/**
 * @title Verifier
 * @dev retrieve value in a vriable
 */
contract VerificationContract {

    DataUsageContract private dc;
    AgreementContract private ac;


    constructor(address dcAdd, address acAdd) {
        dc = DataUsageContract(dcAdd);
        ac = AgreementContract(acAdd);
    }

    

    function verify(address actorAddress, address userAddress, uint usageID, 
        string memory serviceName, string memory operation, string[] memory processedData) public returns (uint){

        uint violator;


        if(isStrEqual(dc.retrieveDataUsage(usageID).operation, operation) &&
            isStrArrayEqual(dc.retrieveDataUsage(usageID).personalData, processedData) &&
             ac.retrieveVote(usageID).consent == true) {
                violator = 0;
        }
        else
            violator = usageID;

        return violator;
    }




    function isStrEqual(string memory a, string memory b) public pure returns (bool) {
        bytes memory aa = bytes(a);
        bytes memory bb = bytes(b);
        if (aa.length != bb.length) return false;
        for(uint i = 0; i < aa.length; i ++) {
            if(aa[i] != bb[i]) return false;
        }
 
        return true;
    }

    function isStrArrayEqual(string[] memory a, string[] memory b) public pure returns (bool) {
        if(a.length == b.length)
        {
            for(uint i=0; i<a.length; i++)
            {
                if(isStrEqual(a[i], b[i]) == false)
                    return false;
            }
            return true;
        }
        else
 
        return false;
    }

}