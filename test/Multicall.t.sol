// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Multicall, Call} from "../src/Multicall.sol";
import {console2} from "forge-std/console2.sol";

// Mock ERC20 balanceOf
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract MockERC20 is IERC20 {
    mapping(address => uint256) public override balanceOf;

    function setBalance(address account, uint256 balance) external {
        balanceOf[account] = balance;
    }
}

contract MulticallTest is Test {
    Multicall public multicall;

    function setUp() public {
        multicall = new Multicall();
    }   

    function test_Multicall() public {
        address addr = address(1);
        address addr2 = address(2);

        // Start prank for addr
        vm.startPrank(addr);
        vm.deal(addr, 1000);
        vm.stopPrank(); // Stop prank after the transaction

        // Start prank for addr2
        vm.startPrank(addr2);
        vm.deal(addr2, 2000);
        vm.stopPrank(); // Stop prank after the transaction

        Call[] memory calls = new Call[](2);
        calls[0] = Call(address(multicall), abi.encodeWithSelector(multicall.getEthBalance.selector, addr));
        calls[1] = Call(address(multicall), abi.encodeWithSelector(multicall.getEthBalance.selector, addr2));

        (, bytes[] memory results) = multicall.multicallView(calls);

        assertEq(abi.decode(results[0], (uint256)), 1000);
        assertEq(abi.decode(results[1], (uint256)), 2000);
    }

    function test_Multicall_ERC20() public {
        MockERC20 token = new MockERC20();
        token.setBalance(address(1), 1000);
        token.setBalance(address(2), 2000);

        Call[] memory calls = new Call[](2);
        calls[0] = Call(address(token), abi.encodeWithSelector(token.balanceOf.selector, address(1)));
        calls[1] = Call(address(token), abi.encodeWithSelector(token.balanceOf.selector, address(2)));

        (, bytes[] memory results) = multicall.multicallView(calls);

        assertEq(abi.decode(results[0], (uint256)), 1000);
        assertEq(abi.decode(results[1], (uint256)), 2000);  
    }   
}
