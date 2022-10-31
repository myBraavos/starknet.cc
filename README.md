# starknet.cc - Advanced Workshop
## Required Setup
### Install the Braavos Extension from the Chrome store
### Go to developer settings, point devnet config to https://devnet.braavos.app port 443
### Switch to Devnet, deploy an account and copy its address and private key so you can __execute__
### Have your favorite tool ready to be able to call the contracts (starknet-cli, starknet.py, starknet.js etc.)
## Lame ERC20
### Limited to 100 tokens per address, 50 tokens per mint
### Owner can bypass the 100 tokens-per-address limit
### Deployed at:
0x057b21c5ec258a1c0a0a44642ce1770cbbe88f44dece71169e7125c1c11676b2
### Code is [here](https://github.com/myBraavos/starknet.cc/tree/main/contracts/openzeppelin/token/erc20)
## Account Owner of Lame ERC20
### Does not verify signature - BUT only allow one call per address
### Limits the number of calls in a multi-call to 2
### Deployed at:
0x0268e1ee7d5de15a28701894c81842d46c88d5491945427bd1f4ed0242d1adc8
### Code is [here](https://github.com/myBraavos/starknet.cc/tree/main/contracts/openzeppelin/account)
## Let's GO
### Warm-up: Mint more than 100 Lame ERC20 into your account address
### GOAL: Mint  A LOT MORE than 100 Lame ERC20 into your account address
### GOD LEVEL: Achieve GOAL in a single call to Owner 🤩
