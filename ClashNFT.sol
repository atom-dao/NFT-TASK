// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*Open Zeppelin contracts*/
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // ERC721 is the NFT standard
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; // Gives methods like totalSupply(), increases gas costs
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // Allows token metadata to be stored on-chain
import "@openzeppelin/contracts/security/Pausable.sol"; // Allows children contracts to stop minting in an emergency
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol"; // To burn (destroy) tokens
import "@openzeppelin/contracts/utils/Counters.sol"; //To keep track of token Ids

/**
 * We are inheriting all the contracts imported above. This means our contract gets all the
 * functions already implemented and audited in them, so we don't need to reinvent the wheel
 */

contract ClashNFT is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Pausable,
    Ownable,
    ERC721Burnable
{
    /**
     *We assign all the methods in the Counters library(such as increment(),decrement(),reset()) to 
      type Counters. A library allows us to reuse already deployed code again and again, thus making the contract gas efficient
     *We need a counter to assign an unique id to each NFT. _tokenIdCounter will do this. 
      It is a state variable hence its value is stored on-chain
     */
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("ClashNFT", "CLASH") {} // initializes token with name and symbol

    function pause() public onlyOwner {
        /**
            Triggers pause state for functions with modifier whenNotPaused
         */
        _pause();
    }

    function unpause() public onlyOwner {
        /**
            Removes paused state and restores normal contract functioning
         */
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        /**
            Function to mint an NFT to the address provided, along with the
            metadata. Can only be called by the contract owner
         */
        uint256 tokenId = _tokenIdCounter.current(); // grabs the current value of _tokenIdCounter
        _safeMint(to, tokenId); // mints the NFT to the address provided and assigns it the current _tokenIdCounter value
        _setTokenURI(tokenId, uri); // sets the metadata of the NFT, uri is a link to IPFS/Arweave containing the NFT metadata
        _tokenIdCounter.increment(); // increment _tokenIdCounter. Ensures that each NFT has an unique tokenId
    }

    function _beforeTokenTransfer(
        /**
            This is called before any token transfer. It is an optional extension of ERC721. Allows us to set 
            totalSupply() and find tokens owners by their index.
         */
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        /**
            Used to burn a token. The caller must be the owner of a tokenId to burn it. The keyword 'override'
            is used to call a virtual function. In ERC721Burnable.sol, _burn() is declaredas a virtual function, 
            which means an inheriting contract (this one) can override its base behaviour.
         */
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        /**
            The following function takes a tokenId and returns the link (eg. IPFS hash) pointing to the metadata of
            the NFT. It is a public view function, meaning anyone can call the function and it makes no state changes to the 
            blockchain, meaning it is gasless.
         */
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        /**
            Returns true if the contract implements an interface as specified in EIP-165(https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
         */
        return super.supportsInterface(interfaceId);
    }
}
