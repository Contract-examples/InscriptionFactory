// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {
    TransparentUpgradeableProxy,
    ITransparentUpgradeableProxy
} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import { ProxyAdmin } from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract InscriptionProxyFactory is Ownable {
    // custom errors
    error ProxyDeployFailed();
    error UpgradeFailed();

    // events
    event ProxyDeployed(address indexed proxy, address indexed implementation);
    event ProxyUpgraded(address indexed proxy, address indexed implementation);

    ProxyAdmin public immutable proxyAdmin;

    constructor() Ownable(msg.sender) {
        proxyAdmin = new ProxyAdmin(msg.sender);
    }

    // deploy proxy
    function deployProxy(address implementation, bytes calldata initData) external onlyOwner returns (address proxy) {
        proxy = address(new TransparentUpgradeableProxy(implementation, address(proxyAdmin), initData));
        if (proxy == address(0)) revert ProxyDeployFailed();

        emit ProxyDeployed(proxy, implementation);
    }

    // upgrade proxy
    function upgradeProxy(address proxy, address newImplementation, bytes calldata data) external onlyOwner {
        try proxyAdmin.upgradeAndCall(ITransparentUpgradeableProxy(proxy), newImplementation, data) {
            emit ProxyUpgraded(proxy, newImplementation);
        } catch {
            revert UpgradeFailed();
        }
    }
}
