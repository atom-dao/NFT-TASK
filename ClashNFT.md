Steps to run the contract:

1. Copy paste the code into Remix IDE and compile
2. Change the deploy environment to Injected Web3(I tested on Rinkeby) 
3. Hit deploy
4. Confirm the transaction on metamask
   

Sample Output:

I followed the above steps and deployed the contract to Rinkeby testnet ( https://rinkeby.etherscan.io/address/0x6Ff7211f205677aD1854bE2D827a01f2cdE3206E ). Then I minted an NFT to myself with this URI https://jsonkeeper.com/b/QS06 by passing my wallet address and the uri into safeMint(), and then approving the transaction from my metamask. The NFT can be viewd on the Opensea testnet at https://testnets.opensea.io/assets?search[query]=0x6Ff7211f205677aD1854bE2D827a01f2cdE3206E .