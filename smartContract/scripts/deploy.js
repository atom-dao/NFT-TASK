const hre = require("hardhat");

async function main() {
    const mint_price = hre.ethers.utils.parseEther("0.01");
    const NFT = await hre.ethers.getContractFactory("NFT_Collection");
    const nft = await NFT.deploy(
        20,
        mint_price,
        "https://crypto-rain.netlify.app/api/"
    );

    await nft.deployed();

    console.log("NFT deployed at:", nft.address);

    await sleep(40000);

    await hre.run("verify:verify", {
        address: nft.address,
        constructorArguments: [
            20,
            mint_price,
            "https://crypto-rain.netlify.app/api/",
        ],
    });
}

function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
