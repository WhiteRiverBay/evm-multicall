// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Multicall {
    function multicall(
        bytes[] calldata data
    ) external returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(
                data[i]
            );
            require(success, "Multicall: delegatecall failed");
            results[i] = result;
        }
    }

    function getBalance(address addr) external view returns (uint256) {
        return addr.balance;
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
