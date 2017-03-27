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

contract Mortal is Owned {
    function kill() ownerOnly {
        suicide(owner);
    }
}


contract Group is Mortal {

    uint[] public members;
    uint public membersCount;

    event MemberAdded(uint index);
    event MemberRemoved(uint index);

    function Group() {
        owner = msg.sender;
    }

    function addMember(uint _index) public ownerOnly {
        members.push(_index);
        membersCount = membersCount + 1;
        MemberAdded(_index);
    }

    function removeMember(uint _index) public ownerOnly {
        delete members[_index];
        membersCount = membersCount - 1;
        MemberRemoved(_index);
    }

}
