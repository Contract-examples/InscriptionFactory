// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/InscriptionProxyFactory.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";

contract UpgradeToV2Script is Script {
    address constant V2_ADDRESS = address(0x5c77Ff2668b4defb7F17B74b9C3d05026E160F78);
    address constant PROXY_ADDRESS = address(0xc7B704D8D43e554518ed324fB85Cd7067B56591d);

    function run() external {
        // TODO: encrypt your private key
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        // start broadcast
        vm.startBroadcast(deployerPrivateKey);

        InscriptionLogicV2 logicV2 = InscriptionLogicV2(V2_ADDRESS);

        InscriptionLogic(PROXY_ADDRESS).upgradeToAndCall(
            address(logicV2), abi.encodeWithSelector(InscriptionLogicV2.initialize.selector, deployerAddress)
        );

        InscriptionLogicV2 logicV2Instance = InscriptionLogicV2(PROXY_ADDRESS);
        address token = logicV2Instance.deployInscription("ISLC2", 1000, 100, 0.01 ether);
        console2.log("Deployed InscriptionLogicV2 token address:", token);
        console2.log("Implementation contract:", logicV2Instance.implementationContract());
        InscriptionLogicV2.TokenInfo memory info = logicV2Instance.getTokenInfo(token);
        console2.log("Token info.totalSupply:", info.totalSupply);
        console2.log("Token info.perMint:", info.perMint);
        console2.log("Token info.mintedAmount:", info.mintedAmount);
        console2.log("Token info.price:", info.price);

        // stop broadcast
        vm.stopBroadcast();
    }
}