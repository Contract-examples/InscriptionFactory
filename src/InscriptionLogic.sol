// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Initializable } from "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { InscriptionToken } from "./InscriptionToken.sol";

contract InscriptionLogic is Initializable, OwnableUpgradeable {
    // custom errors
    error PerMintExceedsTotalSupply();
    error TokenNotDeployedByFactory();
    error ExceedsTotalSupply();

    // events
    event InscriptionDeployed(address indexed tokenAddress, string symbol, uint256 totalSupply, uint256 perMint);
    event InscriptionMinted(address indexed tokenAddress, address indexed to, uint256 amount);

    // token info
    struct TokenInfo {
        uint256 totalSupply;
        uint256 perMint;
        uint256 mintedAmount;
        uint256 price;
    }

    // token info mapping
    mapping(address => TokenInfo) public tokenInfo;

    // implementation contract (for upgrade)
    address public implementationContract;

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        implementationContract = address(new InscriptionToken());
    }

    // deploy inscription token
    function deployInscription(string memory symbol, uint256 totalSupply, uint256 perMint) external returns (address) {
        // if perMint exceeds totalSupply, revert
        if (perMint > totalSupply) revert PerMintExceedsTotalSupply();

        // clone implementation contract
        address newToken = Clones.clone(implementationContract);

        // initialize the token
        InscriptionToken(newToken).initialize(symbol, symbol, address(this));

        // store token info
        tokenInfo[newToken] = TokenInfo({ totalSupply: totalSupply, perMint: perMint, mintedAmount: 0, price: 0 });

        // emit event
        emit InscriptionDeployed(newToken, symbol, totalSupply, perMint);
        return newToken;
    }

    // mint inscription token
    function mintInscription(address tokenAddr) external {
        TokenInfo storage info = tokenInfo[tokenAddr];
        if (info.totalSupply == 0) revert TokenNotDeployedByFactory();
        if (info.mintedAmount + info.perMint > info.totalSupply) revert ExceedsTotalSupply();

        InscriptionToken(tokenAddr).mint(msg.sender, info.perMint);
        info.mintedAmount += info.perMint;

        emit InscriptionMinted(tokenAddr, msg.sender, info.perMint);
    }
}
