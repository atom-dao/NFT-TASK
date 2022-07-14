// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.4;

 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
 import "@openzeppelin/contracts/access/Ownable.sol";
 import "@openzeppelin/contracts/utils/Counters.sol";
 import "@openzeppelin/contracts/security/Pausable.sol";
 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

 contract ERC721Contract is ERC721, Ownable, Pausable, ERC721Enumerable, ERC721Burnable {

    // for incrementing and storing the tokenID of the ERC721 token 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // @dev- fixed variables for mint price and total suppy of ERC721 tokens
    uint256 public MINT_PRICE;
    uint256 public MAX_SUPPLY;

    //sets the name and symbol of ERC721 token
    constructor(uint256 _mintPrice, uint256 _maxSupply) ERC721("ATOMDAOTOKEN", "ATOM") {
        //by default the token counter is 0, bt we want it to be 1
        _tokenIdCounter.increment();
        MINT_PRICE = _mintPrice;
        MAX_SUPPLY = _maxSupply;
    }

    // function to mint
    // @dev - if you only want it to be called by owner, add 'onlyOwner' after 'payable' keyword.
    // @variables - totalSuppy() -> total tokens already minted. (Burned tokens are not counted in this)
    function safeMint(address to) public payable {
        //check if totalSupply is less than max supply
        require(totalSupply() < MAX_SUPPLY, "Can't mint tokens since it has reached max supply");

        // the value of funds provided for minting should be greater than or equal to the mint price.
        require(msg.value >= MINT_PRICE, "not enough ether sent to mint the ERC721 token");

        // set tokenID using counter and increment the _tokenIdCounter.
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        // mint NFT for a given tokenID
        _safeMint(to, tokenId);
    }


    //fuction to withdraw the funds collected by minting from the contract.
    //fuction can only be called by the owner
    function withdraw() public onlyOwner {
        require(address(this).balance < 0, "this contract doesn't have funds right now.");
        payable(owner()).transfer(address(this).balance);
    }

    //function to pause minting incase of an emergency or situation.
    function pause() public onlyOwner{
        _pause();
    }

    //function to unpause minting incase of an emergency.
    function unpause() public onlyOwner {
        _unpause();
    }

    //function to change the baseURI
    function _baseURI() internal pure override returns (string memory) {
        return "fttdh";
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

 }