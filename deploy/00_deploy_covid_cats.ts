import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const RINKEBY_VRF_COORDINATOR = "0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B";
const RINKEBY_LINKTOKEN = "0x01be23585060835e02b77ef475b0cc51aa1e0709";
const RINKEBY_KEYHASH =
  "0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deploy } = hre.deployments;
  const { deployer } = await hre.getNamedAccounts();

  const covidCats = await deploy("CovidCats", {
    from: deployer,
    args: [RINKEBY_VRF_COORDINATOR, RINKEBY_LINKTOKEN, RINKEBY_KEYHASH],
    log: true,
  });

  console.log("Deployed CovidCats to: ", covidCats.address);

  // Verify the contract on Etherscan
  hre.run("verify:verify", {
    address: covidCats.address,
    constructorArguments: [
      RINKEBY_VRF_COORDINATOR,
      RINKEBY_LINKTOKEN,
      RINKEBY_KEYHASH,
    ],
  });
};

export default func;
func.id = "deploy_covid_cats"; // id required to prevent reexecution
func.tags = ["CovidCats"];
