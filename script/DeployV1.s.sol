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

        // deploy
        InscriptionLogic logic = new InscriptionLogic{ salt: SALT }();
        // deployed at: 0x6CeF682028A46015462b176c6F36d2BCb19515EE
        console2.log("InscriptionLogic deployed at:", address(logic));

        // stop broadcast
        vm.stopBroadcast();

        // print deployment info
        console2.log("Deployment completed!");
    }
}
