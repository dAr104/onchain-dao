const hre = require("hardhat");

async function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
    //Deploying nft contract
    const nftContract = await hre.ethers.deployContract("CryptoDevsNFT");
    await nftContract.waitForDeployment();
    console.log("CryptoDevsNFT deployed to:", nftContract.target);

    //Deploying fake nft marketplace contract
    const fakeNftMarketplaceContract = await hre.ethers.deployContract("FakeNFTMarketplace");
    await fakeNftMarketplaceContract.waitForDeployment();
    console.log("FakeNFTMarketplace deployed to:", fakeNftMarketplaceContract.target);

    //Deploying dao contract
    const amount = hre.ethers.parseEther("0.1");
    const daoContract = await hre.ethers.deployContract(
        "CryptoDevsDAO",
        [fakeNftMarketplaceContract.target, nftContract.target],
        { value: amount }
    );
    await daoContract.waitForDeployment();
    console.log("CryptoDevsDAO deployed to:", daoContract.target);

    await sleep(30 * 1000);

    //Verify contracts
    await hre.run("verify:verify", {
        address: nftContract.target,
        constructorArguments: [],
    });

    await hre.run("verify:verify", {
        address: fakeNftMarketplaceContract.target,
        constructorArguments: [],
    });

    await hre.run("verify:verify", {
        address: daoContract.target,
        constructorArguments: [fakeNftMarketplaceContract.target, nftContract.target],
    });
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
