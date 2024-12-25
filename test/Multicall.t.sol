// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Multicall} from "../src/Multicall.sol";

contract MulticallTest is Test {
    Multicall public multicall;

    function setUp() public {
        multicall = new Multicall();
    }   

    function test_Multicall() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSelector(Multicall.getBalance.selector, address(this));
        bytes[] memory results = multicall.multicall(data);
        assertEq(abi.decode(results[0], (uint256)), address(this).balance);
    }
}
