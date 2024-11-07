// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";

contract UpgradeToV2Script is Script {
    address constant V2_ADDRESS = address(0x5c77Ff2668b4defb7F17B74b9C3d05026E160F78);
    address constant PROXY_ADDRESS = address(0x73C21e4421591BBeDd71caF6d8dAA078c95b95c7);
    // address constant TOKEN_V2_ADDRESS = address(0xdF23b8D5FfA1Ad1F2ef08B7C2963A19a9aD894A9);

    function run() external {
        // TODO: encrypt your private key
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        // start broadcast
        vm.startBroadcast(deployerPrivateKey);

        InscriptionLogicV2 logicV2 = InscriptionLogicV2(V2_ADDRESS);

        // upgrade to V2
        InscriptionLogic(PROXY_ADDRESS).upgradeToAndCall(
            address(logicV2), abi.encodeWithSelector(InscriptionLogicV2.initialize.selector, deployerAddress)
        );

        InscriptionLogicV2 logicV2Instance = InscriptionLogicV2(PROXY_ADDRESS);
        address token = logicV2Instance.deployInscription("ISLC2", 1000, 1, 0.01 ether);
        console2.log("Deployed InscriptionLogicV2 token address:", token);
        console2.log("Implementation contract:", logicV2Instance.implementationContract());
        InscriptionLogicV2.TokenInfo memory info = logicV2Instance.getTokenInfo(token);
        console2.log("Token info.totalSupply:", info.totalSupply);
        console2.log("Token info.perMint:", info.perMint);
        console2.log("Token info.mintedAmount:", info.mintedAmount);
        console2.log("Token info.price:", info.price);

        // stop broadcast
        vm.stopBroadcast();

        /*
        == Logs ==
        Deployed InscriptionLogicV2 token address: 0xdF23b8D5FfA1Ad1F2ef08B7C2963A19a9aD894A9
        Implementation contract: 0x3ccfCf3B88593CaA22Fec5376c28E7F42A8B5b9e
        Token info.totalSupply: 1000
        Token info.perMint: 1
        Token info.mintedAmount: 0
        Token info.price: 10000000000000000
         */

        // InscriptionToken inscriptionToken = InscriptionToken(TOKEN_V2_ADDRESS);
        // // InscriptionToken symbol: ISLC2
        // console2.log("InscriptionToken symbol:", inscriptionToken.symbol());
    }
}
