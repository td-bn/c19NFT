import { ethers } from "hardhat";

async function main() {
  const COVIDNFT = await ethers.getContractFactory("COVID");
  const nft = await COVIDNFT.attach(
    "0xCE18dC0BA9F40F812003BE4B182cA584C4c2a0Ff"
  );

  const item = await nft.covidNFT(0);
  console.log("item#0: ", item);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
