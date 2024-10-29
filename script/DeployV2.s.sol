// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/InscriptionProxyFactory.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";

contract DeployV2Script is Script {
    bytes32 constant SALT = bytes32(uint256(0x0000000000000000000000000000000000000000d3bf2663da51c10215000003));

    function run() external {
        // TODO: encrypt your private key
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");

        // start broadcast
        vm.startBroadcast(deployerPrivateKey);

        // deploy
        InscriptionLogicV2 logic = new InscriptionLogicV2{ salt: SALT }();
        // deployed at: 0x5c77Ff2668b4defb7F17B74b9C3d05026E160F78
        console2.log("V2 deployed at:", address(logic));

        // stop broadcast
        vm.stopBroadcast();

        // print deployment info
        console2.log("Deployment completed!");
    }
}
