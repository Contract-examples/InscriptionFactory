// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/InscriptionProxyFactory.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";

contract DeployProxyScript is Script {
    address constant V1_ADDRESS = address(0x6CeF682028A46015462b176c6F36d2BCb19515EE);
    address public proxy;

    function run() external {
        // TODO: encrypt your private key
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        // deploy
        InscriptionProxyFactory factory = new InscriptionProxyFactory();

        // set v1 contract address
        InscriptionLogic logicV1 = InscriptionLogic(V1_ADDRESS);

        // call initialize function using UUPS to deploy proxy
        bytes memory initData = abi.encodeWithSelector(InscriptionLogic.initialize.selector, deployerAddress);

        // start broadcast
        vm.startBroadcast(deployerPrivateKey);

        proxy = factory.deployProxy(address(logicV1), initData);

        // deployed at: 0x2614Bb3b4da2DDCa628052316BEBf25e45FFF75d
        console2.log("Proxy deployed at:", address(proxy));
        console2.log("Deployer address:", deployerAddress);

        // stop broadcast
        vm.stopBroadcast();

        // print deployment info
        console2.log("Deployment completed!");
    }
}
