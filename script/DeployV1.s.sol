// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/InscriptionProxyFactory.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";

contract DeployV1Script is Script {
    bytes32 constant SALT = bytes32(uint256(0x0000000000000000000000000000000000000000d3bf2663da51c10215000003));

    function run() external {
        // TODO: encrypt your private key
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");

        // start broadcast
        vm.startBroadcast(deployerPrivateKey);

        // deploy TokenBank
        InscriptionLogic logic = new InscriptionLogic{ salt: SALT }();
        // InscriptionLogic deployed at: 0xdB3eF3cB3079C93A276A2B4B69087b8801727f64
        console2.log("InscriptionLogic deployed at:", address(logic));

        // stop broadcast
        vm.stopBroadcast();

        // print deployment info
        console2.log("Deployment completed!");
    }
}
