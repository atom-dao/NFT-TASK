# ERC721

Created a ERC721 contract with the basic features such as mintable burnable etc

-   Contract is deployed on mumbai testnet [address - 0x7Df6eb4E12Ab85bEfEC432aFB14dDC2B824667Cd ]

## Deployment

There are three ways to test the code

1. contract is deployed on testnet and also verified, so can easily test on [etherscan](https://mumbai.polygonscan.com/address/0x7Df6eb4E12Ab85bEfEC432aFB14dDC2B824667Cd#code) ,but for operations to do with ownership the ownership need to change so, dm me with address to change ownership

2. deploy using remix

    - Open Remix and create a .sol file, copy the code into Remix
    - Environment : Injected Web3
    - Choose a network and Deploy
    - enter the mintPrice(in wei), maxSupply, and the baseURI
    - use these base uri `https://crypto-rain.netlify.app/api/`

3. if you are familiar with hardhat follow the below steps

    - Open your terminal/cmd in the `/SmartContract` folder

    - Install yarn if not installed

        ```sh
          npm install --global yarn
        ```

    - Install dependencies
        ```sh
          yarn install
        ```

-   Run `npx hardhat run --network hardhat scripts/deploy.js` to deploy smart-contract within hardhat network.

-   Run test scripts or test over development server
