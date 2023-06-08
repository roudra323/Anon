const hre = require("hardhat");

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const Message = await hre.ethers.getContractFactory("Message");
  const contract = await Message.deploy();
  await contract.deployed();
  console.log(
    "Owner address: ",
    owner.address,
    " contract address: ",
    contract.address
  );
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
