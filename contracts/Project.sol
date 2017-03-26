pragma solidity ^0.4.9;

import "LunchPay.sol";

contract Project {
    address public manager;

    address constant NAME_REG_ADDRESS = 0x92C292cB254393F4dA22D92CA42B27375f3ebc7A;


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

    function assignMemberToLunchPay(string _name, string _lunchPay) public managerOnly {
        address lunchPayAddr = NameReg(NAME_REG_ADDRESS).addressOf(_lunchPay);

        for (uint i=0; i<members.length; i++) {
            if(members[i].active == true) {
                 LunchPay(lunchPayAddr).addMember(i);
            }
        }

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

        bool s = LunchPay(from).broadcastNextPayer(members[index].name);
        BroadcastedEvent(from, members[index].name, s);
        return true;
    }

    function registerPayment(address from, address payer, uint[] _diners) public returns(bool)  {

        uint index = 0;

        for (uint i=0; i<_diners.length; i++) {
            if(members[_diners[i]].active == true) {
                if (members[_diners[i]].addr == payer) {
                    index = _diners[i];
                    members[_diners[i]].balance = members[_diners[i]].balance + int(_diners.length) - 1;
                } else {
                    members[_diners[i]].balance = members[_diners[i]].balance - 1;
                }
            }
        }

        bool s = LunchPay(from).broadcastPayment(members[index].name);

        return true;
    }

}

contract NameReg {
    function register(bytes32 name);
    function unregister();
    function addressOf(string _name) returns (address);
 }
