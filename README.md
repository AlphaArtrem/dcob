# Digital Certification Over Blockchain

An Decentralised Autonomous Organisation build using Solidity for Smart Contracts and Flutter for the front-end for creating and verifying certificates with the feature to vote in new issuers of certificates. The smart contract can be deployed on any EVM based chain.
#
## Installation

1. Clone the repository
```
git clone git@github.com:AlphaArtrem/dcob.git
```
2. Install truffle
```
cd contracts
npm install -g truffle
```
3. Install node dependencies
```
npm install
```
4. Compile the smart contract
```
truffle compile
```  
5. Create a new file ```.secret``` in same directory and add your 12 words mnemonic in the file.
```
touch .secret
```
6. Open the file ```truffle-config.js``` and change the ```deployment``` network settings with the desired chain configurations and then deploy the contract.
```
truffle migrate –-network deployment
```
7. Save the ```contract address``` after deployment.
```
1_deploy_contracts.js
=====================

   Deploying 'Certificate'
   -----------------------
   > transaction hash:    0xdad633bceec116a67530f0097aeda9efab3a7ace684fb4b4991eebe20702c0a0
   > Blocks: 0            Seconds: 0
   > contract address:    0x601565cDC1e0A9079AD8508E18f16e2E173042A5***
   > block number:        5
   > block timestamp:     1684404758
   > account:             0xe7F8bd83F0a2BddaCCFB056D431134d44FF02033
   > balance:             99.980996372942756496
   > gas used:            3202532 (0x30dde4)
   > gas price:           3.076621899 gwei
   > value sent:          0 ETH
   > total cost:          0.009852980083448268 ETH

   > Saving artifacts
   -------------------------------------
   > Total cost:     0.009852980083448268 ETH

Summary
=======
> Total deployments:   1
> Final cost:          0.009852980083448268 ETH

```
8. Install and setup flutter <a href = "https://docs.flutter.dev/get-started/install">using the docs here</a>.
9. In the asset's folder rename the ```env_dummy.json``` file to ```env.json``` and the fill all the required JSON data.
```
{
    "ipfsInfuraApiKey" : "ipfsInfuraApiKey",
    "ipfsInfuraApiSecretKey" : "ipfsInfuraApiSecretKey",
    "contractAddress" : "contractAddress",
    "rpcUrl" : "rpcUrl"
}
```
You can get the Infura key and secret from <a href = "https://www.infura.io/">infura.io</a>. The contract address will be provide in the ```step 7```. RPC URL will be your chain's rpc url.

10. Fetch pub dependencies for Flutter and run the app.
```
flutter pub get
flutter run
```