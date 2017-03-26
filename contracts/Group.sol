pragma solidity ^0.4.9;

contract Group {

    address public owner;
    uint[] public members;

    modifier ownerOnly {
        if (msg.sender != owner) {
            throw;
        } else {
            _;
        }
    }

    function Group() {
        owner = msg.sender;
    }

    function addMember(uint index) public ownerOnly {
        members.push(index);
    }

    function removeMember(uint index) public ownerOnly {
        delete members[index];
    }

}
