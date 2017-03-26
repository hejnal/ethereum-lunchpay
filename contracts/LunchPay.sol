pragma solidity ^0.4.9;

import "Group.sol";

contract NameReg {
    function register(bytes32 name);
    function unregister();
 }

 contract LunchPay is Group {

     event NextPayer(string _nextPayer);
     event Consulted(address to, bool success);

     string public name;
     address projectContract;

     address constant NAME_REG_ADDRESS = 0x0dcd2f752394c41875e259e00bb44fd505297caf;

     function LunchPay(string _name, address _projectContract) {
         name = _name;
         projectContract = _projectContract;

         bytes32 converted;

         assembly {
             converted := mload(add(_name, 32))
         }

         NameReg(NAME_REG_ADDRESS).register(converted);
     }

     function broadCastNextPayer(string _nextPayer) public returns(bool) {
         NextPayer(_nextPayer);
     }

     function consultNextPayer() public {
         members.push(0);

         bool s = Project(projectContract).broadcastNextPayer(address(this), members);

         Consulted(projectContract, s);

     }

     function pay(uint[] diners) public {

     }

 }
