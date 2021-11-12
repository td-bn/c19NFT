import { provider, wallet } from "./wallet"
const ethers = require("ethers");

const address = "0x01be23585060835e02b77ef475b0cc51aa1e0709"; //RINKEBY LINK TOKEN ADDRESS

const abi = [
    {
        "constant":false,
        "inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],
        "name":"transfer",
        "outputs":[{"name":"success","type":"bool"}],
        "payable":false,
        "stateMutability":"nonpayable",
        "type":"function"
    }
];

const link_contract = new ethers.Contract(address, abi, provider);
const link_contract_connected = link_contract.connect(wallet);

export async function transferLink(_address: string) {
    await link_contract_connected.transfer(_address, ethers.utils.parseEther("5")) // ADJUST NUMBER HERE TO ADJUST LINK SENT
    console.log(`5 LINK TRANSFERRED!`)
}