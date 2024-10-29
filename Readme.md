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
factory deployed at: 0x698B7eb92Cc151f6D63667ca48130D8f554a53B4
OwnershipTransferred (index_topic_1 address previousOwner, index_topic_2 address newOwner)
[topic0] 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0
[topic1] 0x0000000000000000000000000000000000000000000000000000000000000000
[topic2] 0x0000000000000000000000004e59b44847b379578588920ca78fbf26c0b4956c
```


## Deploy Proxy
```
forge script script/DeployProxy.s.sol:DeployProxyScript --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```

## Result of "Deploy Proxy"
```
https://sepolia.arbiscan.io/address/0x6cef682028a46015462b176c6f36d2bcb19515ee
```

