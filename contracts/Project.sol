pragma solidity ^0.4.9;


contract Project {
    address public manager;

    Person[] public members;

    string[] public lunchPayContracts;

    event LunchPayCreated(address addr);
    event BroadcastedEvent(address to, string nextPayer, bool success);

    struct Person {
        address addr;
        string name;
        int balance;
        bool active;
    }

    modifier managerOnly {
        if (msg.sender != manager) {
            throw;
        } else {
            _;
        }
    }

    function Project() {
        manager = msg.sender;
    }

    function addMember(address _member, string _name) public managerOnly {
        members.push(Person({addr: _member, name:_name, balance:0, active:true}));
    }

    function removeMember(address _member) public managerOnly {
        //delete members[_medmber];
    }

    function changeManager(address _newManager) public managerOnly {
        manager = _newManager;
    }

    function createLunchPay(string _name) public {
        lunchPayContracts.push(_name);
        address adr = new LunchPay(_name, address(this));
        LunchPayCreated(adr);
    }

    function broadcastNextPayer(address from, uint[] _members) public returns(bool)  {
        uint index = 0;
        int minValue = 100000000;

        for (uint i=0; i<_members.length; i++) {
            if(members[_members[i]].active == true
                && members[_members[i]].balance < minValue) {
                minValue = members[_members[i]].balance;
                index = _members[i];
            }
        }

        bool s = LunchPay(from).broadCastNextPayer(members[index].name);
        BroadcastedEvent(from, members[index].name, s);
        return true;
    }

}


contract NameReg {
    function register(bytes32 name);
    function unregister();
 }
