pragma solidity ^0.4.9;

import "Group.sol";
import "Project.sol";

contract LunchPay is Group {

    event NextPayer(string _nextPayer);
    event PaymentDone(string _payaer);

    event Consulted(address to, bool success);

    string public name;
    address projectContract;

    address constant NAME_REG_ADDRESS = 0x92C292cB254393F4dA22D92CA42B27375f3ebc7A;

    function LunchPay(string _name, address _projectContract) {
        name = _name;
        projectContract = _projectContract;

        bytes32 converted;

        assembly {
            converted := mload(add(_name, 32))
        }

        NameReg(NAME_REG_ADDRESS).register(converted);
    }

    function broadcastNextPayer(string _nextPayer) public returns(bool) {
        NextPayer(_nextPayer);
    }

    function broadcastPayment(string _payer) public returns(bool) {
        PaymentDone(_payer);
    }

    function consultNextPayer() public {
        members.push(0);

        bool s = Project(projectContract).broadcastNextPayer(address(this), members);

        Consulted(projectContract, s);

    }

    function pay(uint[] diners) public {
        bool s = Project(projectContract).registerPayment(address(this), msg.sender, diners);

        Consulted(projectContract, s);
    }

}
