// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; 

contract ERC721Contract is ERC721URIStorage, Ownable, Pausable {

    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _totalSupply;

    uint public MAX_SUPPLY;

    uint public mintPrice;

    string _baseTokenURI;

    error AllNFTHasBeingMinted();

    error InSufficientAmount(uint mintAmount, uint Amount);

    error BalanceIsZero();

    event MintPriceUpdated( uint OldPrice,uint NewPrice);

    event Mint(uint tokenId, address owner);




    /**
     * @dev Initializes the contract by setting a `name`,`symbol`, 
     * MaxSupply, mintPrice and baseURL to the token collection.
     */
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint _maxSupply, 
        uint _mintPrice,
        string memory baseURI)
        ERC721(_name, _symbol) {
        MAX_SUPPLY = _maxSupply;
        mintPrice = _mintPrice;
        setBaseUrl(baseURI);

    }


    /**
     * @dev Safely mints to `msg.sender`.
     *
     * Requirements:
     * - `numberOfMint` number of token you want to mint;
     * - `msg.value` must be equal to `numberOfMint`* `mintPrice`
     * - `MAX_SUPPLY` has not being exceeded.
     * - If `msg.sender` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Mint} event.
     */
    function mint(uint numberOfMint) public payable whenNotPaused returns(bool){
        if(_totalSupply.current() == MAX_SUPPLY){
            revert AllNFTHasBeingMinted();
        }
        uint _mintAmount = numberOfMint*mintPrice;

        if(msg.value < _mintAmount){
            revert InSufficientAmount({mintAmount: _mintAmount, Amount: msg.value});
        }

        if(numberOfMint > 1){
            for(uint i = 0; i < numberOfMint; i++){
                _totalSupply.increment();
                
                _safeMint(msg.sender,_totalSupply.current());
                string memory _tokenId = Strings.toString(_totalSupply.current());
                _setTokenURI(_totalSupply.current(), string(abi.encodePacked(_baseTokenURI, _tokenId, ".json")));
                emit Mint(_totalSupply.current(), msg.sender);
            }
        }

       if(numberOfMint <= 1){
        _totalSupply.increment();
        _safeMint(msg.sender, _totalSupply.current());
        string memory _tokenId = Strings.toString(_totalSupply.current());
        _setTokenURI(_totalSupply.current(), string(abi.encodePacked(_baseTokenURI, _tokenId, ".json")));
        emit Mint(_totalSupply.current(), msg.sender);
       }

       return true;
    }

    /**
     * @dev update `mintPrice` 
     *
     * Requirement
     * - `msg.sender` must be the `owner`
     */

    function updateMintPrice(uint _mintPrice) public onlyOwner returns(bool){
        uint BeforePriceUpdate = mintPrice;
        mintPrice = _mintPrice;
        uint AfterPriceUpdate = mintPrice;
        emit MintPriceUpdated(BeforePriceUpdate, AfterPriceUpdate);
        return true;
    }
    

        /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     */
    function burn(uint tokenId) public returns(bool){
        _burn(tokenId);
        return true;
    }


    /**
     * @dev Returns the total token Minted.
     */
    function totalMinted() public view returns(uint){
        return _totalSupply.current();
    }


    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function pauseMinting() external onlyOwner returns(bool){
        _pause();
        return true;
    }


     /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function unPauseMinting() external onlyOwner returns(bool){
        _unpause();
        return true;
    }
    
    

    /**
     * @dev set the Base URI
     *
     * Requirements
     * - can Only be called by `owner`
     */
    function setBaseUrl(string memory baseURI) public onlyOwner returns(bool){
        _baseTokenURI = baseURI;
        return true;
    }



    /**
     * @dev withdraw the balance of the contract to `msg.sender`
     *
     * Requirement
     * - Can only be called by the `owner`
     */
    function withdraw() external onlyOwner returns(bool){
        if(address(this).balance < 0){
            revert BalanceIsZero();
        }
        payable(msg.sender).transfer(address(this).balance);
        return true;
    }
}
