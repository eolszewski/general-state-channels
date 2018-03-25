pragma solidity ^0.4.18;

import "./InterpreterInterface.sol";

contract InterpretBidirectional is InterpreterInterface {
    // State
    // [0-31] isClose flag
    // [32-63] address sender
    // [64-95] address receiver
    // [96-127] bond 
    // [128-159] balance of receiver

    uint256 totalBond = 0;
    // This always returns true since the receiver should only
    // sign and close the highest balance they have
    function isClose(bytes _data) public returns(bool) {
        return true;
    }

    function isSequenceHigher(bytes _data1, bytes _data2) public pure returns (bool) {
        uint isHigher1;
        uint isHigher2;

        assembly {
            isHigher1 := mload(add(_data1, 64))
            isHigher2 := mload(add(_data2, 64))
        }

        require(isHigher1 > isHigher2);
        return true;
    }

    // just look for receiver sig
    function quickClose(bytes _data) public returns (bool) {
        _decodeState(_data);
        require(balanceA + balanceB == totalBond);
        return true;
    }

    function startSettleStateGame(uint _gameIndex, bytes _state, uint8[2] _v, bytes32[2] _r, bytes32[2] _s) public {

    }

    function closeWithTimeoutGame(uint _gameIndex, uint8[2] _v, bytes32[2] _r, bytes32[2] _s) public {

    }


    function initState(bytes _state, uint8[2] _v, bytes32[2] _r, bytes32[2] _s) public returns (bool) {
        _decodeState(_state);
    }

    function _decodeState(bytes _state) {
        // SPC State
        // [
        //    32 isClose
        //    64 sequence
        //    96 numInstalledChannels
        //    128 address 1
        //    160 address 2
        //    192 balance 1
        //    224 balance 2
        //    256 channel 1 state length
        //    288 channel 1 interpreter type
        //    320 channel 1 CTF address
        //    [
        //        isClose
        //        sequence
        //        settlement period length
        //        channel specific state
        //        ...
        //    ]
        //    channel 2 state length
        //    channel 2 interpreter type
        //    channel 2 CTF address
        //    [
        //        isClose
        //        sequence
        //        settlement period length
        //        channel specific state
        //        ...
        //    ]
        //    ...
        // ]

        uint256 _bond;
        uint256 _balanceA;
        uint256 _balanceB;


        assembly {
            _bond := mload(add(_state, 256))
            _balanceA := mload(add(_state, 288))
            _balanceB := mload(add(_state, 320))
        }

        balanceA = _balanceA;
        balanceB = _balanceB;
    }
}