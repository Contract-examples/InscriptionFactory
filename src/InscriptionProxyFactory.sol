// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { UUPSUpgradeable } from "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

// UUPS proxy factory(ERC1967)
contract InscriptionProxyFactory is Ownable {
    // custom error
    error ProxyDeployFailed();
    error UpgradeFailed();

    // event
    event ProxyDeployed(address indexed proxy, address indexed implementation);

    constructor() Ownable(msg.sender) { }

    // deploy proxy
    function deployProxy(address implementation, bytes calldata initData) external onlyOwner returns (address proxy) {
        // use erc1967 proxy to deploy proxy
        proxy = address(new ERC1967Proxy(implementation, initData));
        if (proxy == address(0)) revert ProxyDeployFailed();

        // emit event
        emit ProxyDeployed(proxy, implementation);
    }
}


