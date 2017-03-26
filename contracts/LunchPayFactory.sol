pragma solidity ^0.4.9;

import "LunchPay.sol";

contract LunchPayFactory {
    string[] lunchPayContracts;

    function create(string _name) returns(address) {
        lunchPayContracts.push(_name);
        return address(new LunchPay(_name));
    }

}
