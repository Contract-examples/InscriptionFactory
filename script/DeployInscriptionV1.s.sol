// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";

contract DeployInscriptionV1Script is Script {
    address constant V1_ADDRESS = address(0x6CeF682028A46015462b176c6F36d2BCb19515EE);
    address constant PROXY_ADDRESS = address(0x73C21e4421591BBeDd71caF6d8dAA078c95b95c7);
    //   address constant TOKEN_ADDRESS = address(0xe413e5d03880746377ff76e72c9174B487B78788);

    function run() external {
        // TODO: encrypt your private key
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        // start broadcast
        vm.startBroadcast(deployerPrivateKey);

        // deploy inscription V1
        InscriptionLogic logicV1 = InscriptionLogic(PROXY_ADDRESS);

        address token = logicV1.deployInscription("ISLC1", 1000, 100);
        console2.log("Deployed InscriptionV1 token address:", token);

        // InscriptionToken inscriptionToken = InscriptionToken(TOKEN_ADDRESS);
        // // InscriptionToken symbol: ISLC1
        // console2.log("InscriptionToken symbol:", inscriptionToken.symbol());

        // stop broadcast
        vm.stopBroadcast();
    }
}
