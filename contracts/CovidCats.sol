/** TO-DO
 * 
 * Determine how to store metadata in a format that OpenSea will accept
 */


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CovidCats is ERC721, VRFConsumerBase, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;
    
    // NFT CONSTANTS
    Counters.Counter private _tokenSupply;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.1 ether;

    bool public saleIsActive = false;
    string private _baseTokenURI;
    
    event Mint(address indexed _minter, uint256 indexed _tokenID, string[6] traits);

    // DECLARING CHAINLINK VRF FUNCTION CONSTANTS
    bytes32 internal keyHash; //Public key against which randomness is generated
    uint256 internal fee; //Fee required to fulfil a VRF request
    mapping(bytes32 => address) requestToSender;
    mapping(address => bool) isClaiming;
    IERC20 public LINK_token;
    
    // TRAITS
    string[] private face = [
        "face1",
        "face2",
        "face3",
        "face4",
        "face5"
    ];

    uint256[] private face_weights = [
        20,
        20,
        20,
        20,
        20
    ];

    string[] private ear = [
        "ear1",
        "ear2",
        "ear3",
        "ear4",
        "ear5",
        "ear6",
        "ear7"
    ];

    uint256[] private ear_weights = [
        10,
        10,
        10,
        10,
        10,
        10,
        40
    ];
    string[] private mouth = [
        "mouth1",
        "mouth2",
        "mouth3",
        "mouth4",
        "mouth5"
    ];

    uint256[] private mouth_weights = [
        20,
        20,
        20,
        20,
        20
    ];

    string[] private eye = [
        "eye1",
        "eye2",
        "eye3",
        "eye4",
        "eye5",
        "eye6"
    ];

    uint256[] private eye_weights = [
        20,
        20,
        20,
        20,
        10,
        10
    ];

    string[] private whisker = [
        "whisker1",
        "whisker2",
        "whisker3",
        "whisker4",
        "whisker5",
        "whisker6",
        "whisker7",
        "whisker8",
        "whisker9"
    ];

    uint256[] private whisker_weights = [
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        20
    ];

    string[] private mask = [
        "mask1",
        "mask2",
        "mask3",
        "mask4",
        "mask5"
    ];

    uint256[] private mask_weights = [
        20,
        20,
        20,
        20,
        20
    ];

    constructor( address _VRFCoordinator, address _linkToken, bytes32 _keyHash)
        VRFConsumerBase(_VRFCoordinator, _linkToken)
        ERC721("CovidCats", "CovidCat")
        Ownable() {
            LINK_token = IERC20(_linkToken);
            keyHash = _keyHash;
            fee = 0.1 * 10 ** 18;
    }

    /** 
     * NFT Helper Functions
     */

    // I wonder how many JPEGs are left?
    function remainingSupply() public view returns (uint256) {
        return MAX_SUPPLY - _tokenSupply.current();
    }

    // I wonder how many JPEGs are minted?
    function tokenSupply() public view returns (uint256) {
        return _tokenSupply.current();
    }

    // All the functions you don't really care about but need to be here
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // Go go go!
    function toggleSale() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    // You had to expect this function, right?
    function withdrawBalance() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /** 
     * Requests random number from Chainlink VRF function
     */
    function claim() public payable returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        require(saleIsActive, "Minting not open yet!");
        uint256 mintIndex = _tokenSupply.current() + 1; // Start IDs at 1
        require(mintIndex <= MAX_SUPPLY, "No more CovidCats available to mint :(");
        require(isClaiming[msg.sender] == false, "YOU CANNOT CLAIM ANOTHER NFT YET");
        require(msg.value >= MINT_PRICE, "Not enough ETH to buy a CovidCat!");

        requestId = requestRandomness(keyHash, fee);
        requestToSender[requestId] = msg.sender;
        isClaiming[msg.sender] = true;
    }

    /**
     * Callback function used by VRF Coordinator
     * Using "Having multiple VRF requests in flight" pattern as per https://docs.chain.link/docs/chainlink-vrf-best-practices/
     * Also using "Getting multiple random numbers" pattern
     * Also using "Getting a random number within a range" pattern
     * NOTE that this function has a gas limit of 200,000 or it will as per Chainlink docs
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        
        // Get tokenId for this NFT mint
        uint256 id = _tokenSupply.current() + 1;

        address initiator = requestToSender[requestId];
        
        // Get 6 random numbers in the range from 1 to 100
        uint256[6] memory randomValues;
        
        for (uint256 i = 0; i < 6; i++) {
            randomValues[i] = uint256(keccak256(abi.encode(randomness, i)));
            randomValues[i] = (randomValues[i] % 100) + 1;
        }

        // Use above 6 random numbers and trait weights to randomly generate traits
        uint256 sum;
        
        string memory _face;
        string memory _ear;
        string memory _mouth;
        string memory _eye;
        string memory _whisker;
        string memory _mask;

        for (uint i = 0; i < face_weights.length; i++) {
            sum += face_weights[i];
            if (sum >= randomValues[0]) {
                _face = face[i];
                sum = 0;
                break;
            }
        }

        for (uint i = 0; i < ear_weights.length; i++) {
            sum += ear_weights[i];
            if (sum >= randomValues[1]) {
                _ear = ear[i];
                sum = 0;
                break;
            }
        }

        for (uint i = 0; i < mouth_weights.length; i++) {
            sum += mouth_weights[i];
            if (sum >= randomValues[2]) {
                _mouth = mouth[i];
                sum = 0;
                break;
            }
        }

        for (uint i = 0; i < eye_weights.length; i++) {
            sum += eye_weights[i];
            if (sum >= randomValues[3]) {
                _eye = eye[i];
                sum = 0;
                break;
            }
        }

        for (uint i = 0; i < whisker_weights.length; i++) {
            sum += whisker_weights[i];
            if (sum >= randomValues[4]) {
                _whisker = whisker[i];
                sum = 0;
                break;
            }
        }

        for (uint i = 0; i < mask_weights.length; i++) {
            sum += mask_weights[i];
            if (sum >= randomValues[5]) {
                _mask = mask[i];
                sum = 0;
                break;
            }
        }
        
        // Mint NFT
        _safeMint(initiator, id);
        
        emit Mint(initiator, id, 
            [_face,
            _ear,
            _mouth,
            _eye,
            _whisker,
            _mask]
            );

        isClaiming[initiator] = false;
    }

    // Withdraw function to avoid locking your LINK in the contract
    function withdrawLink() onlyOwner external {
        uint256 LINK_balance = LINK_token.balanceOf(address(this));
        LINK_token.safeTransfer(msg.sender, LINK_balance);
    }
}
