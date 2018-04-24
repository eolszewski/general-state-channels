pragma solidity ^0.4.23;

contract LibInterpreterInterface {

    function finalizeState(bytes _state) public returns (bool) {}

    function update(address _b, uint256 _a) public returns (bool) {}
}