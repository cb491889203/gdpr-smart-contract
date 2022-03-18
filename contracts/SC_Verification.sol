// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SC_Agreement.sol";
import "./SC_DataUsage.sol";
import "./Lib.sol";

/**
 * @title Verifier
 * @dev retrieve value in a vriable
 */
contract VerificationContract {

    DataUsageContract private dc;
    AgreementContract private ac;

    // Store all the violators in each 


    constructor(address dcAdd, address acAdd) {
        dc = DataUsageContract(dcAdd);
        ac = AgreementContract(acAdd);
    }

    // event for EVM logging
    event Verification(address indexed dataUsageContractAddress,address indexed agreementContractAddress, address violatorAddress);
    event ViolationDectected(address violator,string message);

    function verify(address actorAddress, address userAddress, uint usageID, 
        string memory serviceName, string memory operation, string[] memory processedData) public returns (address){

        address violator;
        DataUsage memory dataUsage = dc.retrieveDataUsage(usageID);
        Vote memory vote = ac.retrieveVote(usageID);

        //whether or not the addresses of actors recorded by the log smart contract conform to 
        //those actors who have been given the consent by the users through the agreement 
        //smart contract.
        if(userAddress!=dataUsage.userAddress || userAddress!=vote.userAddress){
            violator = actorAddress;
            emit ViolationDectected(violator,"user address inconformity");
        }   
        else if(actorAddress!=dataUsage.actorAddress || actorAddress!=vote.actorAddress){
            violator = actorAddress;
            emit ViolationDectected(violator,"actor address inconformity");
        }
        //whether or not the operations of each actor recorded by the log contract conform to 
        //those operations which were recorded via the data usage contract and were given the 
        //users’ consent through the agreement contract.
        else if(!isStrEqual(dataUsage.operation, operation)){
            violator = actorAddress;
            emit ViolationDectected(violator,"operation record inconformity");
        }
        //whether or not the processed personal data that were recorded by the log contract 
        //were already confirmed by the users through the agreement contract.
        else if(!isStrArrayEqual(processedData, dataUsage.personalData)){
            violator = actorAddress;
            emit ViolationDectected(violator,"request processed data inconformity");
        }
        //check whether the request above is confirmed by the user subject  
        else if(!vote.consent){
            violator = actorAddress;
            emit ViolationDectected(violator,"data usage is not confirmed by user");
        }
       else {
            violator = address(0x0);
       }  
            
        emit Verification(address(dc), address(ac), violator);
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

    function isStrArrayEqual(string[] memory a, string[] memory b) public returns (bool) {
        if(a.length <= b.length) {
            bool find;
            for(uint i=0; i<a.length; i++) {
                string memory processed = a[i];
                find = false;
                for (uint j = 0; j < b.length; j++) {
                    if(isStrEqual(processed, b[j])) {
                        find = true;
                        emit ViolationDectected(address(0), string(abi.encodePacked(processed, " -- ",b[j])));
                        break;
                    }
                } 
                if (!find) {
                    emit ViolationDectected(address(0), string(abi.encodePacked(processed, " : can't find!!!")));
                    return false;
                }
            }
            return true;
        } else {
            emit ViolationDectected(address(0), "a.length > b.length");
            return false;
        }
            
    }

}