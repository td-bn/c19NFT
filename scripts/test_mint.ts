import { transferLink } from "./helpers/link_contract";
import { claim, withdrawLink, findMintEvent } from "./helpers/covidcats_contract";
import hre, { ethers } from "hardhat";

const address = "0xaa00a05f3e8f113a41f54585ffe2bbdae8063e25" // CHANGE DEPLOYED COVID CATS CONTRACT ADDRESS HERE
// Is there a way to programatically change the above address to link to the most recent deployment?

async function test_mint(_address: string) {
    // Send 5 LINK from my address to the contract
    await transferLink(_address)

    // Call claim()
    await claim(_address);

    // Call withdrawLink()
    await withdrawLink(_address);
}

// test_mint(address)

(async () => {
	const traits = await findMintEvent(address, 0)
    console.log(traits);
})();