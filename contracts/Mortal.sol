pragma solidity ^0.4.9;
import "Owned.sol";

contract Mortal is Owned {
    function kill() ownerOnly {
        suicide(owner);
    }
}
