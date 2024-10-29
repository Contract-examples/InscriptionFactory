// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { UUPSUpgradeable } from "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import { Initializable } from "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { InscriptionToken } from "./InscriptionToken.sol";

// V1 InscriptionLogic
contract InscriptionLogic is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    // custom error
    error PerMintExceedsTotalSupply();
    error TokenNotDeployedByFactory();
    error ExceedsTotalSupply();

    // event
    event InscriptionDeployed(address indexed tokenAddress, string symbol, uint256 totalSupply, uint256 perMint);
    event InscriptionMinted(address indexed tokenAddress, address indexed to, uint256 amount);

    // token struct
    struct TokenInfo {
        uint256 totalSupply; // total supply
        uint256 perMint; // per mint amount
        uint256 mintedAmount; // minted amount
    }

    // token info
    mapping(address => TokenInfo) public tokenInfo;

    // implementation contract
    address public implementationContract;

    constructor() {
        // disable initializer
        _disableInitializers();
    }

    // upgradeable init
    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();

        // Deploy a token implementation contract as template
        InscriptionToken tokenImpl = new InscriptionToken();
        implementationContract = address(tokenImpl);
    }

    // deploy inscription
    function deployInscription(string memory symbol, uint256 totalSupply, uint256 perMint) external returns (address) {
        if (perMint > totalSupply) revert PerMintExceedsTotalSupply();

        // Create new token using clone pattern
        address newToken = Clones.clone(implementationContract);

        // Initialize the new token
        InscriptionToken(newToken).initialize(symbol, symbol, address(this));

        tokenInfo[newToken] = TokenInfo({ totalSupply: totalSupply, perMint: perMint, mintedAmount: 0 });

        emit InscriptionDeployed(newToken, symbol, totalSupply, perMint);
        return newToken;
    }

    // mint inscription
    function mintInscription(address tokenAddr) external {
        TokenInfo storage info = tokenInfo[tokenAddr];
        if (info.totalSupply == 0) revert TokenNotDeployedByFactory();
        if (info.mintedAmount + info.perMint > info.totalSupply) revert ExceedsTotalSupply();

        InscriptionToken(tokenAddr).mint(msg.sender, info.perMint);
        info.mintedAmount += info.perMint;

        emit InscriptionMinted(tokenAddr, msg.sender, info.perMint);
    }

    // authorize upgrade only owner
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner { }
}
