// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
data usage of actor.
*/
struct DataUsage {
    address  actorAddress;
    address  userAddress;
    string  serviceName;
    string servicePurpose;
    string  operation;
    // ["name", "gender", "address"]
    string[]  personalData;
}

/**
Represent user's vote for data usage by an actor.
*/
struct Vote {
    address actorAddress;
    address userAddress;
    uint usageID;
    bool consent;
}

/**
Represent the log of processed persoanl data by an actor
*/
struct LogContent {
    address actorAddress; 
    address userAddress;
    uint usageID;
    string serviceName;
    string operation;
    // ["name", "gender"]
    string[] processedData;
}