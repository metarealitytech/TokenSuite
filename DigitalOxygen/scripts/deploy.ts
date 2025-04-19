import { ethers } from "hardhat";

async function main() {
  const Token = await ethers.getContractFactory("DigitalOxygen");
  const token = await Token.deploy();
  await token.deployed();
  console.log("DigitalOxygen deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
