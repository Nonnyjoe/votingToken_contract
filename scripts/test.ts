import { ethers } from "hardhat";

async function main() {
    const [owner, owner2] = await ethers.getSigners();

    const mynft = await ethers.getContractFactory("EthersFuture");

    const Mynft = await mynft.deploy("Ether's Future", "ETF");
    await Mynft.deployed()
    const contractAddress = Mynft.address;
    console.log("contractAddress");
//////////////////////////////////////////////////
    const mint = await Mynft.safeMint(owner.address, "Qmb73Tx9QSkvj638nJ5FzCpss6BH2acEdiWbRHPGU8TMX1");
    console.log(mint);
    //const uri = await Mynft.tokenURI()

}