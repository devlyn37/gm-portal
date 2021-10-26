// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract GmPortal {
    uint256 totalGms;
    mapping(address => uint256) public numGms;

    constructor() {
        console.log("gm");
    }

    function gm() public {
        totalGms += 1;
        numGms[msg.sender] += 1;
        console.log("%s has said gm!", msg.sender);
    }

    function getTotalGms() public view returns (uint256) {
        console.log("We have %d total gms!", totalGms);
        return totalGms;
    }
}
