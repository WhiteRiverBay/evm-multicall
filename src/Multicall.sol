// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


struct Call {
        address target;
    bytes callData;
}

contract Multicall {
    function multicall(
        Call[] calldata calls
    ) external returns (uint256 blockNumber, bytes[] memory results) {
        blockNumber = block.number;
        results = new bytes[](calls.length);
        for (uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory result) = calls[i].target.call(
                calls[i].callData
            );
            require(success, "Multicall: call failed");
            results[i] = result;
        }
    }


    function getBlockHash(
        uint256 blockNumber
    ) public view returns (bytes32 blockHash) {
        blockHash = blockhash(blockNumber);
    }

    function getBlockNumber() public view returns (uint256 blockNumber) {
        blockNumber = block.number;
    }

    function getCurrentBlockCoinbase() public view returns (address coinbase) {
        coinbase = block.coinbase;
    }

    function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
        gaslimit = block.gaslimit;
    }

    function getCurrentBlockTimestamp()
        public
        view
        returns (uint256 timestamp)
    {
        timestamp = block.timestamp;
    }

    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }

    function getLastBlockHash() public view returns (bytes32 blockHash) {
        blockHash = blockhash(block.number - 1);
    }

    function getCurrentBlockRandomNumber()
        public
        view
        returns (uint256 randomNumber)
    {
        randomNumber = block.prevrandao;
    }
}
