// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Initializable } from "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { InscriptionToken } from "./InscriptionToken.sol";

contract InscriptionLogicV2 is Initializable, OwnableUpgradeable {
    // custom errors
    error PerMintExceedsTotalSupply();
    error TokenNotDeployedByFactory();
    error ExceedsTotalSupply();
    error InsufficientPayment();

    // events
    event InscriptionDeployed(
        address indexed tokenAddress, string symbol, uint256 totalSupply, uint256 perMint, uint256 price
    );
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

    // implementation contract
    address public implementationContract;

    function initialize() public reinitializer(2) {
        implementationContract = address(new InscriptionToken());
    }

    // deploy inscription token
    function deployInscription(
        string memory symbol,
        uint256 totalSupply,
        uint256 perMint,
        uint256 price
    )
        external
        returns (address)
    {
        // if perMint exceeds totalSupply, revert
        if (perMint > totalSupply) revert PerMintExceedsTotalSupply();

        // clone implementation contract
        address newToken = Clones.clone(implementationContract);

        // initialize the token
        InscriptionToken(newToken).initialize(symbol, symbol, address(this));

        // store token info
        tokenInfo[newToken] = TokenInfo({ totalSupply: totalSupply, perMint: perMint, mintedAmount: 0, price: price });

        // emit event
        emit InscriptionDeployed(newToken, symbol, totalSupply, perMint, price);
        return newToken;
    }

    // mint inscription token (payable)
    function mintInscription(address tokenAddr) external payable {
        TokenInfo storage info = tokenInfo[tokenAddr];
        if (info.totalSupply == 0) revert TokenNotDeployedByFactory();
        if (info.mintedAmount + info.perMint > info.totalSupply) revert ExceedsTotalSupply();
        if (msg.value < info.price * info.perMint) revert InsufficientPayment();

        InscriptionToken(tokenAddr).mint(msg.sender, info.perMint);
        info.mintedAmount += info.perMint;

        emit InscriptionMinted(tokenAddr, msg.sender, info.perMint);
    }

    // withdraw fees
    function withdrawFees() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
