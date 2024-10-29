# Inscription Factory
UUPS proxy factory(ERC1967)


## Install deps
```
forge install
```

## Test
```
forge test -vv
```

## The result of testing
```
Ran 5 tests for test/InscriptionTest.t.sol:InscriptionTest
[PASS] test_DeployInscriptionV1() (gas: 213221)
Logs:
  Proxy address: 0x104fBc016F4bb334D775a19E8A6510109AC63E00
  Deployed token address: 0x0401911641c4781D93c41f9aa8094B171368E6a9

[PASS] test_DeployProxy() (gas: 5417)
[PASS] test_MintInscriptionV2() (gas: 3541609)
Logs:
  Deployed token address: 0x20067a7558168e12ad53b235F2f7408FeEa4985F
  Implementation contract: 0x0401911641c4781D93c41f9aa8094B171368E6a9
  Token info.totalSupply: 1000
  Token info.perMint: 100
  Token info.mintedAmount: 0
  Token info.price: 100000000000000000
  User1 balance: 0
  Proxy balance: 10000000000000000000

[PASS] test_UpgradeToV2() (gas: 3460134)
Logs:
  Deployed token address: 0x20067a7558168e12ad53b235F2f7408FeEa4985F
  Implementation contract: 0x0401911641c4781D93c41f9aa8094B171368E6a9
  Token info.totalSupply: 1000
  Token info.perMint: 100
  Token info.mintedAmount: 0
  Token info.price: 100000000000000000

[PASS] test_WithdrawFeesV2() (gas: 3548530)
Logs:
  Deployed token address: 0x20067a7558168e12ad53b235F2f7408FeEa4985F
  Implementation contract: 0x0401911641c4781D93c41f9aa8094B171368E6a9
  User2 balance: 0
  Proxy balance: 10000000000000000000
  Owner balance before: 79228162514264337593543950335
  Proxy balance before: 10000000000000000000
  Owner balance after: 79228162524264337593543950335
  Proxy balance after: 0

Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 1.76ms (2.41ms CPU time)

Ran 1 test suite in 16.89ms (1.76ms CPU time): 5 tests passed, 0 failed, 0 skipped (5 total tests)
```

## Deploy V1
```
forge script script/DeployV1.s.sol:DeployV1Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy V1"
```
V1 deployed at:0x6CeF682028A46015462b176c6F36d2BCb19515EE
```

## Deploy ProxyFactory
```
forge script script/DeployProxyFactory.s.sol:DeployProxyFactoryScript --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy ProxyFactory"
```
factory deployed at: 0x6b006fD6F9c965Ff2c6B7127Ecc2d230aCc18e76 
```


## Deploy Proxy
```
forge script script/DeployProxy.s.sol:DeployProxyScript --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy Proxy"
```
Proxy deployed at: 0xc7B704D8D43e554518ed324fB85Cd7067B56591d
```


## Deploy InscriptionV1
```
forge script script/DeployInscriptionV1.s.sol:DeployInscriptionV1Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy InscriptionV1"
```
txhash:https://sepolia.arbiscan.io/tx/0x0e625cf4320b3f73a0cb3f73a2dde50db3a376416b8816f8ca0714066714fa3b
Deployed InscriptionV1 token address: 0xe413e5d03880746377ff76e72c9174B487B78788
```

## Deploy V2
```
forge script script/DeployV2.s.sol:DeployV2Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy V2"
```
txhash:https://sepolia.arbiscan.io/tx/0xed817f928f6e8082e884ffae9bc4e97728660a9b71b9f57e91899f8ceabd0f34
V2 deployed at:0x5c77Ff2668b4defb7F17B74b9C3d05026E160F78
```


## Upgrade to V2
```
forge script script/UpgradeToV2.s.sol:UpgradeToV2Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Upgrade to V2"
```
txhash:https://sepolia.arbiscan.io/tx/0x3089871cb71c7bdaa8ab944cb61a47c415a3af33e9678cafb691c6ffbc5b8f86
  Deployed InscriptionLogicV2 token address: 0xFeBcDAd45083e5b3eBf30e0F974FC081bcd76CF9
  Implementation contract: 0x267dcfe927125553108D305a4b398041115bd8Da
  Token info.totalSupply: 1000
  Token info.perMint: 100
  Token info.mintedAmount: 0
  Token info.price: 10000000000000000
```

## Upgrade to V2
```
forge script script/MintInscriptionV2.s.sol:MintInscriptionV2Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Upgrade to V2"
```
txhash:https://sepolia.arbiscan.io/tx/0x3089871cb71c7bdaa8ab944cb61a47c415a3af33e9678cafb691c6ffbc5b8f86
```

