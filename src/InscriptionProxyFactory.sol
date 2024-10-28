// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InscriptionProxyFactory is Ownable {
    ProxyAdmin public immutable proxyAdmin;

    constructor() Ownable(msg.sender) {
        proxyAdmin = new ProxyAdmin(msg.sender);
    }

    // deploy proxy
    function deployProxy(address logic, bytes memory data) external onlyOwner returns (address) {
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(logic, address(proxyAdmin), data);
        return address(proxy);
    }

    // upgrade proxy
    function upgradeProxy(address proxy, address newImplementation, bytes memory data) external onlyOwner {
        proxyAdmin.upgradeAndCall(ITransparentUpgradeableProxy(proxy), newImplementation, data);
    }
}
