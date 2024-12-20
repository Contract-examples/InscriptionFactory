// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/InscriptionLogic.sol";
import "../src/InscriptionLogicV2.sol";

contract MintInscriptionV2Script is Script {
    //address constant V2_ADDRESS = address(0x5c77Ff2668b4defb7F17B74b9C3d05026E160F78);
    address constant PROXY_ADDRESS = address(0x73C21e4421591BBeDd71caF6d8dAA078c95b95c7);
    address constant TOKEN_V2_ADDRESS = address(0xdF23b8D5FfA1Ad1F2ef08B7C2963A19a9aD894A9);

    function run() external {
        // TODO: encrypt your private key
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        // start broadcast
        vm.startBroadcast(deployerPrivateKey);

        InscriptionLogicV2 logicV2 = InscriptionLogicV2(PROXY_ADDRESS);

        logicV2.mintInscription{ value: 0.011 ether }(TOKEN_V2_ADDRESS);

        console2.log("User balance:", deployerAddress.balance);
        console2.log("Proxy balance:", address(PROXY_ADDRESS).balance);

        /*
            == Logs ==
            User balance: 465081263447760000
            Proxy balance: 11000000000000000
        */
        // stop broadcast
        vm.stopBroadcast();
    }
}
