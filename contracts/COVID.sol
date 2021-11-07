// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract COVID is ERC721, VRFConsumerBase, Ownable {
    bytes32 keyHash;
    uint256 fee;

    struct NFT {
        uint256 trait1;
    }

    NFT[] public covidNFT;

    mapping(bytes32 => address) requestToSender;

    string[] private trait1 = [
        "option1",
        "option2",
        "option3",
        "option4",
        "option5",
        "option6",
        "option7",
        "option8",
        "option9",
        "option10"
    ];

    constructor( address _VRFCoordinator, address _linkToken, bytes32 _keyHash)
        VRFConsumerBase(_VRFCoordinator, _linkToken)
        ERC721("COVID", "C19")
        Ownable() {
            keyHash = _keyHash;
            fee = 0.1 * 10 ** 18;
    }

    function claim() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");

        requestId = requestRandomness(keyHash, fee);
        requestToSender[requestId] = msg.sender;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        address initiator = requestToSender[requestId];
        uint256 id =  covidNFT.length;

        // Do something with randomness; randomness -> traits mapping
        uint256 trait1Index = randomness%10;

        // Push traits to struct
        covidNFT.push( NFT(trait1Index));

        // Mint Token
        _safeMint(initiator, id);
    }
}