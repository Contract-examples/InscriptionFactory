// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";

// Upgradeable version of ERC20 token
contract InscriptionToken is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    constructor() {
        _disableInitializers();
    }

    function initialize(string memory name, string memory symbol, address initialOwner) external initializer {
        __ERC20_init(name, symbol);
        __Ownable_init(initialOwner);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
