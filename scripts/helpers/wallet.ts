require('dotenv').config({path: '../../.env'})
const ethers = require("ethers");
export const provider = new ethers.providers.JsonRpcProvider(process.env.RINKEBY_URL, "rinkeby");
export const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);