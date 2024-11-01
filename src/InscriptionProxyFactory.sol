// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { UUPSUpgradeable } from "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

// salt for proxy deployment
bytes32 constant SALT = bytes32(uint256(0x0000000000000000000000000000000000000000d3bf2663da51c10215000003));

// UUPS proxy factory(ERC1967)
contract InscriptionProxyFactory is Ownable {
    // custom error
    error ProxyDeployFailed();

    // event
    event ProxyDeployed(address indexed proxy, address indexed implementation);

    constructor(address initialOwner) Ownable(initialOwner) {
        // NOTE: do not use "msg.sender" here, because it will be the proxy address
    }

    // deploy proxy
    function deployProxy(address implementation, bytes calldata initData) external onlyOwner returns (address proxy) {
        // use erc1967 proxy to deploy proxy
        proxy = address(new ERC1967Proxy{ salt: SALT }(implementation, initData));
        if (proxy == address(0)) revert ProxyDeployFailed();

        // emit event
        emit ProxyDeployed(proxy, implementation);
    }
}
