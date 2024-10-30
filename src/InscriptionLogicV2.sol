// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { UUPSUpgradeable } from "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import { Initializable } from "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { InscriptionToken } from "./InscriptionToken.sol";

// V2 version
contract InscriptionLogicV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    // custom error
    error PerMintExceedsTotalSupply();
    error TokenNotDeployedByFactory();
    error ExceedsTotalSupply();
    error InsufficientPayment();

    // event
    event InscriptionDeployed(
        address indexed tokenAddress, string symbol, uint256 totalSupply, uint256 perMint, uint256 price
    );
    event InscriptionMinted(address indexed tokenAddress, address indexed to, uint256 amount);

    // token struct
    struct TokenInfo {
        uint256 totalSupply; // total supply
        uint256 perMint; // per mint amount
        uint256 mintedAmount; // minted amount
        uint256 price; // price
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
    function initialize(address initialOwner) public reinitializer(2) {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();

        // Deploy a token implementation contract as template
        InscriptionToken tokenImpl = new InscriptionToken();
        implementationContract = address(tokenImpl);
    }

    // deploy inscription
    function deployInscription(
        string memory symbol,
        uint256 totalSupply,
        uint256 perMint,
        uint256 price
    )
        external
        returns (address)
    {
        // check per mint amount
        if (perMint > totalSupply) revert PerMintExceedsTotalSupply();

        // Create new token using clone pattern
        address newToken = Clones.clone(implementationContract);

        // Initialize the new token
        InscriptionToken(newToken).initialize(symbol, symbol, address(this));

        // update token info
        tokenInfo[newToken] = TokenInfo({ totalSupply: totalSupply, perMint: perMint, mintedAmount: 0, price: price });

        // emit event
        emit InscriptionDeployed(newToken, symbol, totalSupply, perMint, price);
        return newToken;
    }

    // mint inscription
    function mintInscription(address tokenAddr) external payable {
        TokenInfo storage info = tokenInfo[tokenAddr];

        // check token is deployed by factory
        if (info.totalSupply == 0) revert TokenNotDeployedByFactory();
        // check per mint amount
        if (info.mintedAmount + info.perMint > info.totalSupply) revert ExceedsTotalSupply();

        // check payment
        if (msg.value < info.price * info.perMint) revert InsufficientPayment();

        // mint token
        InscriptionToken(tokenAddr).mint(msg.sender, info.perMint);

        // update minted amount
        info.mintedAmount += info.perMint;

        // emit event
        emit InscriptionMinted(tokenAddr, msg.sender, info.perMint);
    }

    // withdraw fees
    function withdrawFees() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // authorize upgrade(only owner)
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner { }

    // get token info
    function getTokenInfo(address token) external view returns (TokenInfo memory) {
        return tokenInfo[token];
    }
}
