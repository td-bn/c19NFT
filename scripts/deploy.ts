// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
const hre = require("hardhat");

const RINKEBY_VRF_COORDINATOR = "0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B";
const RINKEBY_LINKTOKEN = "0x01be23585060835e02b77ef475b0cc51aa1e0709";
const RINKEBY_KEYHASH = "0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const CovidCats = await ethers.getContractFactory("CovidCats");
  
  const covidCats = await CovidCats.deploy(
    RINKEBY_VRF_COORDINATOR,
    RINKEBY_LINKTOKEN,
    RINKEBY_KEYHASH
  );

  await covidCats.deployed();
  console.log("COVIDNFT contract deployed to:", covidCats.address);
  
  // Wait 5 blocks after contract deploy transactions to be safe to avoid Etherscan error 
  // where you are asking for contract verification before the contract is indexed on Etherscan
  await covidCats.deployTransaction.wait(5)

  // Verify the contract on Etherscan
  await hre.run("verify:verify", {
    address: covidCats.address,
    constructorArguments: [
      RINKEBY_VRF_COORDINATOR,
      RINKEBY_LINKTOKEN,
      RINKEBY_KEYHASH
    ]
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});