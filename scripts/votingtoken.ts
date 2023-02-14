import { ethers } from "hardhat";

async function main() {
  const [owner, owner2] = await ethers.getSigners();

  //const CloneMultiSig = await ethers.getContractFactory("votingToken");
  const VotingToken = await ethers.getContractFactory("votingToken");
  //console.log(await ethers.getContractFactory("cloneMultiSig"));
  const votingToken = await VotingToken.deploy(100000000000, "NONSO INU", "NNS");
  await votingToken.deployed();
  
  console.log(`VotingToken Address is ${votingToken.address}`);
  //console.log(addr1.address, addr2.address, owner.address);

////////////////////////////////////////////////////////////
// DEPLOYMENT COMPLETED.... INTERACTION WITH CONTRACT BEGINS
////////////////////////////////////////////////////////////
const purchaseToken = await votingToken.PurchaseToken({value: ethers.utils.parseEther("0.01")})
//console.log(purchaseToken);
//await purchaseToken.wait();

const createPool = await votingToken.createVotePool2(1000,"0x13B109506Ab1b120C82D0d342c5E64401a5B6381","0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb", "0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4");
let event = await createPool.wait();
//console.log(event);
//let child = await event.events[1].args;
//let voteId = child[0];
//console.log(`VOTE POOL ID IS ${voteId}`);
const contenders = votingToken.DisplayContenders(1000);
const contenders2 = await contenders;
console.log(await contenders2);
const vote = await votingToken.Vote(1000, "0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4", "0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb", "0x13B109506Ab1b120C82D0d342c5E64401a5B6381");

// close voting pool
await votingToken.closeVotingPool(1000);
const closePool = votingToken.closeVotingPool(1000);
const win = await votingToken.DisplayWinner(1000);
const winner = await win;
console.log(winner);
//await votingToken.vote(voteId, "0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4", "0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb", "0x13B109506Ab1b120C82D0d342c5E64401a5B6381")
//const newMultisig = await cloneMultiSig.createMultiSig(admin);
  //let event = await newMultisig.wait();
  //console.log(event);
  //let newChild = event.events[0].args[0];
  //console.log(newChild);

  //////////////////////////////////////////////////

  //const childMultisig = await ethers.getContractAt("IMultisig", newChild);
  //const addresses = await childMultisig.returnAdmins();
  //console.log(addresses);

  //await childMultisig.addAdmin("0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb");
  //await childMultisig.connect(owner2).addAdmin("0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb");

  //const addressesNew = await childMultisig.returnAdmins();
  //console.log(addressesNew);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});