// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/InscriptionProxyFactory.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";
import "../src/InscriptionToken.sol";

contract InscriptionTest is Test {
    InscriptionProxyFactory public factory;
    InscriptionLogic public logicV1;
    InscriptionLogicV2 public logicV2;
    address public proxy;

    address public owner = address(this);
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");

    event InscriptionDeployed(
        address indexed tokenAddress, string symbol, uint256 totalSupply, uint256 perMint, uint256 price
    );
    event InscriptionMinted(address indexed tokenAddress, address indexed to, uint256 amount);

    // add receive function to receive ETH
    receive() external payable { }

    function setUp() public {
        factory = new InscriptionProxyFactory();
        logicV1 = new InscriptionLogic();

        bytes memory initData = abi.encodeWithSelector(InscriptionLogic.initialize.selector, owner);
        proxy = factory.deployProxy(address(logicV1), initData);
    }

    function test_DeployProxy() public {
        assertTrue(proxy != address(0));
    }

    function test_DeployInscriptionV1() public {
        vm.startPrank(owner);
        InscriptionLogic logic = InscriptionLogic(proxy);

        console.log("Proxy address:", address(proxy));

        address token = logic.deployInscription("test1", 1000, 100);
        console.log("Deployed token address:", token);

        assertTrue(token != address(0));
        InscriptionToken inscriptionToken = InscriptionToken(token);
        assertEq(inscriptionToken.symbol(), "test1");
        vm.stopPrank();
    }

    function test_UpgradeToV2() public {
        vm.startPrank(owner);

        logicV2 = new InscriptionLogicV2();

        InscriptionLogic(proxy).upgradeToAndCall(
            address(logicV2), abi.encodeWithSelector(InscriptionLogicV2.initialize.selector, owner)
        );

        InscriptionLogicV2 logicV2Instance = InscriptionLogicV2(proxy);
        address token = logicV2Instance.deployInscription("test2", 1000, 100, 0.1 ether);

        assertTrue(token != address(0));
        InscriptionToken inscriptionToken = InscriptionToken(token);
        assertEq(inscriptionToken.symbol(), "test2");
        vm.stopPrank();
    }

    function test_MintInscriptionV2() public {
        vm.startPrank(owner);

        logicV2 = new InscriptionLogicV2();
        InscriptionLogic(proxy).upgradeToAndCall(
            address(logicV2), abi.encodeWithSelector(InscriptionLogicV2.initialize.selector, owner)
        );

        InscriptionLogicV2 logicV2Instance = InscriptionLogicV2(proxy);
        address token = logicV2Instance.deployInscription("test2", 1000, 100, 0.1 ether);
        vm.stopPrank();

        vm.deal(user1, 10 ether);
        vm.startPrank(user1);
        logicV2Instance.mintInscription{ value: 10 ether }(token);

        InscriptionToken inscriptionToken = InscriptionToken(token);
        assertEq(inscriptionToken.balanceOf(user1), 100);
        assertEq(address(proxy).balance, 10 ether);
        vm.stopPrank();
    }

    function test_WithdrawFeesV2() public {
        vm.startPrank(owner);

        logicV2 = new InscriptionLogicV2();
        InscriptionLogic(proxy).upgradeToAndCall(
            address(logicV2), abi.encodeWithSelector(InscriptionLogicV2.initialize.selector, owner)
        );

        InscriptionLogicV2 logicV2Instance = InscriptionLogicV2(proxy);
        address token = logicV2Instance.deployInscription("test2", 1000, 100, 0.1 ether);
        vm.stopPrank();

        vm.deal(user2, 10 ether);
        vm.startPrank(user2);
        logicV2Instance.mintInscription{ value: 10 ether }(token);
        vm.stopPrank();

        uint256 ownerBalanceBefore = owner.balance;
        vm.startPrank(owner);
        logicV2Instance.withdrawFees();
        assertEq(owner.balance - ownerBalanceBefore, 10 ether);
        assertEq(address(proxy).balance, 0);
        vm.stopPrank();
    }
}
