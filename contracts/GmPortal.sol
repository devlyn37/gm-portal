// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

/// @title A silly little message board
/// @author Devlyn Dorfer (completing Buildspace project)
/// @notice The current randomization method could be gamed
contract GmPortal {
    uint256 totalGms;
    uint256 private seed;

    event NewGm(
        address indexed from,
        uint256 timestamp,
        string message,
        uint8 status
    );

    struct Gm {
        address gmer;
        string message;
        uint256 timestamp;
        uint8 status; // 0 = no streak, 1 = win, 2 = loss
    }

    Gm[] gms;
    mapping(address => uint256) public lastGm;

    /// @dev generates the initial randomization seed
    constructor() payable {
        console.log("gm");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    /// Send a message, maybe win some eth
    /// @param _message the message specified by the sender
    /// @notice send message, sender may win eth if they send 23-25 hrs after their prev message
    function gm(string memory _message) public {
        require(
            lastGm[msg.sender] + 23 hours < block.timestamp,
            "Another Gm can be sent after 23 hours"
        );

        totalGms += 1;
        console.log("%s has said gm!", msg.sender);

        /*
         * Generate a new seed for the next user that sends a gm
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        bool consecutive = lastGm[msg.sender] + 25 hours > block.timestamp;
        bool winner = consecutive && seed <= 10;
        uint8 status = consecutive ? winner ? 1 : 2 : 0;

        lastGm[msg.sender] = block.timestamp;
        gms.push(Gm(msg.sender, _message, block.timestamp, status));

        if (winner) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        console.log("Status: %d", status);
        emit NewGm(msg.sender, block.timestamp, _message, status);
    }

    /// @return gms a list of all messages
    function getAllGms() public view returns (Gm[] memory) {
        return gms;
    }

    /// @return totalGms the number of messages sent
    function getTotalGms() public view returns (uint256) {
        console.log("We have %d total gms!", totalGms);
        return totalGms;
    }
}
