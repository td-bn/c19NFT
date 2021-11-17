// npx hardhat run scripts/test_mint.ts --network rinkeby

import { transferLink } from "./helpers/link_contract";
import { claim, withdrawLink, withdrawBalance, toggleSale, getEvent } from "./helpers/covidcats_contract";

const address = "0xe904ce0B59EeD931980B204E99c1cA801313C9da" // CHANGE DEPLOYED COVID CATS CONTRACT ADDRESS HERE
// Is there a way to programatically change the above address to link to the most recent deployment?

async function test_mint(_address: string) {
    
    // Turn minting on
    await toggleSale(_address)

    // Send 5 LINK from my address to the contract
    await transferLink(_address)

    // Claim NFT - Use a while loop to keep attempting claim() until success
    // One error reason - Calling script too many times in a short period of time. The Chainlink VRF takes a minute or two to return a random number to then call the mint logic
    let claimed = false;

    while (!claimed) {
        try {
            await claim(_address);
            claimed = true;
        } catch {
            console.log("FAILED CLAIM");
        }
    }

    // Call withdrawLink()
    await withdrawLink(_address);

    // Get ETH back lol
    await withdrawBalance(_address);

    // Listen to Mint event => Return the newly minted NFT's traits
    await getEvent(_address)
}

test_mint(address)