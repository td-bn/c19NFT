// Helper script for programmatically verifying contract on Etherscan, run the following command:
// npx hardhat verify --network rinkeby INSERT_CONTRACT_ADDRESS --constructor-args scripts/constructor_args.ts

module.exports = [
    "0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B", // RINKEBY_VRF_COORDINATOR
    "0x01be23585060835e02b77ef475b0cc51aa1e0709",  // RINKEBY_LINKTOKEN
    "0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311"  // RINKEBY_KEYHASH
  ];