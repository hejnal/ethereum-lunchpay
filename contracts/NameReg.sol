pragma solidity ^0.4.9;
import "Group.sol";

contract NameReg is Mortal {

    mapping(address => bytes32) toName;
    mapping(bytes32 => address) toAddress;
    mapping(bytes32 => address) nameOwner;

    event Register(address indexed addr, bytes32 name);
    event Unregister(address indexed addre, bytes32 name);

    function NameReg() {
        toName[this] = "NameReg";
        toAddress["NameReg"] = this;
        nameOwner["NameReg"] = msg.sender;

        Register(this, "NameReg");
    }

    function register(bytes32 name) {
        if (toAddress[name] != address(0) && nameOwner[name] != tx.origin) return;

        bytes32 oldName = toName[msg.sender];
        if (oldName != "") {
            toAddress[oldName] = address(0);
            nameOwner[oldName] = address(0);

            Unregister(msg.sender, oldName);
        }

        toName[msg.sender] = name;
        toAddress[name] = msg.sender;
        nameOwner[name] = tx.origin;

        Register(msg.sender, name);
    }

    function unregister() {
        bytes32 name = toName[msg.sender];
        if (name == "" || nameOwner[name] != tx.origin) return;

        toName[msg.sender] = "";
        toAddress[name] = address(0);
        nameOwner[name] = address(0);

        Unregister(msg.sender, name);
    }

    function addressOf(string name) constant returns(address addr) {
        return toAddress[stringToBytes32(name)];
    }

    function nameOf(address addr) constant returns(string name) {
        return bytes32ToString(toName[addr]);
    }

    function bytes32ToString(bytes32 x) internal constant returns(string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

    function stringToBytes32(string memory source) internal returns(bytes32 result) {
        assembly {
            result: = mload(add(source, 32))
        }
    }
}
