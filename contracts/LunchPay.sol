pragma solidity ^0.4.9;
import "Group.sol";
import "Project.sol";

contract LunchPay is Group {

    event NextPayer(string _nextPayer);
    event PaymentDone(string _payer);

    event Consulted(address to, bool success);

    string public name;
    address projectContract;

    address public nameRegAddress;

    function LunchPay(string _name, address _nameRegAddress, address _projectContract) {
        name = _name;
        projectContract = _projectContract;
        nameRegAddress = _nameRegAddress;

        bytes32 converted;

        assembly {
            converted: = mload(add(_name, 32))
        }

        NameReg(nameRegAddress).register(converted);
    }

    function broadcastNextPayer(string _nextPayer) public returns(bool) {
        NextPayer(_nextPayer);
    }

    function broadcastPayment(string _payer) public returns(bool) {
        PaymentDone(_payer);
    }

    function consultNextPayer() public {
        bool s = Project(projectContract).broadcastNextPayer(address(this), members);

        Consulted(projectContract, s);

    }

    function pay(uint[] diners) public {
        bool s = Project(projectContract).registerPayment(address(this), msg.sender, diners);

        Consulted(projectContract, s);
    }
}
