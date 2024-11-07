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
[PASS] test_DeployInscriptionV1() (gas: 212604)
Logs:
  Proxy address: 0x2614Bb3b4da2DDCa628052316BEBf25e45FFF75d
  Deployed token address: 0xB7832aeA4E300C0b7E1BD0F34bA4CF0a62202aAA

[PASS] test_DeployProxy() (gas: 5417)
Logs:
  Proxy address: 0x2614Bb3b4da2DDCa628052316BEBf25e45FFF75d

[PASS] test_MintInscriptionV2() (gas: 3541609)
Logs:
  Proxy address: 0x2614Bb3b4da2DDCa628052316BEBf25e45FFF75d
  Deployed token address: 0xf7a06Dd7aB15e561A712431f48c17E6e7c8c1a2f
  Implementation contract: 0xB7832aeA4E300C0b7E1BD0F34bA4CF0a62202aAA
  Token info.totalSupply: 1000
  Token info.perMint: 100
  Token info.mintedAmount: 0
  Token info.price: 100000000000000000
  User1 balance: 0
  Proxy balance: 10000000000000000000

[PASS] test_UpgradeToV2() (gas: 3460167)
Logs:
  Proxy address: 0x2614Bb3b4da2DDCa628052316BEBf25e45FFF75d
  Deployed token address: 0xf7a06Dd7aB15e561A712431f48c17E6e7c8c1a2f
  Implementation contract: 0xB7832aeA4E300C0b7E1BD0F34bA4CF0a62202aAA
  Token info.totalSupply: 1000
  Token info.perMint: 100
  Token info.mintedAmount: 0
  Token info.price: 100000000000000000

[PASS] test_WithdrawFeesV2() (gas: 3548530)
Logs:
  Proxy address: 0x2614Bb3b4da2DDCa628052316BEBf25e45FFF75d
  Deployed token address: 0xf7a06Dd7aB15e561A712431f48c17E6e7c8c1a2f
  Implementation contract: 0xB7832aeA4E300C0b7E1BD0F34bA4CF0a62202aAA
  User2 balance: 0
  Proxy balance: 10000000000000000000
  Owner balance before: 79228162514264337593543950335
  Proxy balance before: 10000000000000000000
  Owner balance after: 79228162524264337593543950335
  Proxy balance after: 0

Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 2.94ms (2.77ms CPU time)

Ran 1 test suite in 13.44ms (2.94ms CPU time): 5 tests passed, 0 failed, 0 skipped (5 total tests)
```

## Deploy V1
```
forge script script/DeployV1.s.sol:DeployV1Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy V1"
```
V1 deployed at:0x6CeF682028A46015462b176c6F36d2BCb19515EE
```

## Deploy Proxy
```
forge script script/DeployProxy.s.sol:DeployProxyScript --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy Proxy"
```
Proxy deployed at: 0x73C21e4421591BBeDd71caF6d8dAA078c95b95c7
```


## Deploy InscriptionV1
```
forge script script/DeployInscriptionV1.s.sol:DeployInscriptionV1Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy InscriptionV1"
```
txhash:https://sepolia.arbiscan.io/tx/0x8afc8aeb1e7a57a5d6facd3949d72ef227d66b22eb7e37536425f690a18ac561
Deployed InscriptionV1 token address: 0x4117bBa2d4EDBf3ef87e4e5A058b28C4fDB05C4D
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
txhash:https://sepolia.arbiscan.io/tx/0xf51eb88baf6e69d955cf6186b21258b8a2b410350eefa6c075a361387b339013
== Logs ==
  Deployed InscriptionLogicV2 token address: 0xdF23b8D5FfA1Ad1F2ef08B7C2963A19a9aD894A9
  Implementation contract: 0x3ccfCf3B88593CaA22Fec5376c28E7F42A8B5b9e
  Token info.totalSupply: 1000
  Token info.perMint: 1
  Token info.mintedAmount: 0
  Token info.price: 10000000000000000
```

## Mint InscriptionV2
```
forge script script/MintInscriptionV2.s.sol:MintInscriptionV2Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Mint InscriptionV2"
```
txhash:https://sepolia.arbiscan.io/tx/0xba9b9f520a325f160c0d4040c3aa9f136c54dfbe08d2c7428ae449d15ec46a11
== Logs ==
  User balance: 365739320539440000
  Proxy balance: 11000000000000000
```


## Withdraw fee V2
```
forge script script/WithdrawFeesV2.s.sol:WithdrawFeesV2Script --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Withdraw fee V2"
```
txhash:https://sepolia.arbiscan.io/tx/0x65d92d5bdc545cca9986a6723a25c3f857df49772eef75f9bbc63c2ff0c5c429
== Logs ==
  User balance: 376728045639440000
  Proxy balance: 0
```


