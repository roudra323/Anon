// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Message {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    mapping(address => string) internal msgInfo;

    function writeMsg(string memory msg_) public OnlyOwner {
        msgInfo[msg.sender] = msg_;
    }

    function readMsg(address addr_)
        public
        view
        OnlyOwner
        returns (string memory msg_)
    {
        msg_ = msgInfo[addr_];
    }
}
