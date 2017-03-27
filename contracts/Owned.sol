pragma solidity ^0.4.9;

contract Owned {
    address owner;

    function owned() {
        owner = msg.sender;
    }

    modifier ownerOnly {
        if (msg.sender != owner) {
            throw;
        } else {
            _;
        }
    }
}
