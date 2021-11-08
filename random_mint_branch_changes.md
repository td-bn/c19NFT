scripts/deploy.ts
- Added programmatic Etherscan contract verification

scripts/constructor_args.tx
- Helper script to help with programmatic Etherscan contract verification

contracts/CovidCats.sol
- Renamed COVID.sol to CovidCats.sol
- Added withdrawLink() function to prevent locking of LINK tokens
- Added arrays to represent NFT traits and desired rarity weights
- Added to fulfillRandomness() function to generate random set of NFT traits (as per predefined trait weight arrays) and mint this NFT