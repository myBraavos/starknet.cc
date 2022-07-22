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
0x033d9ba8785940ffa668cf9fe25db349890e3b41bbefeccb61c3821b03f62152
### Code is [here](https://github.com/myBraavos/starknet.cc/tree/main/contracts/openzeppelin/token/erc20)
## Account Owner of Lame ERC20
### Does not verify signature in __execute__ - BUT only allow one call per address
### Limits the number of calls in a multi-call to 2
### Deployed at:
0x02eab3f5b9a470c0ae9458501544a7d2f276c6d32853248bb5990f777a93d1e7
### Code is [here](https://github.com/myBraavos/starknet.cc/tree/main/contracts/openzeppelin/account)
## Let's GO
### Warm-up: Mint more than 100 Lame ERC20 into your account address
### GOAL: Mint  A LOT MORE than 100 Lame ERC20 into your account address
### GOD LEVEL: Achieve GOAL in a single call to Owner 🤩
