// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/utils/CountersUpgradeable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/utils/StringsUpgradeable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/proxy/utils/Initializable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/access/AccessControlUpgradeable.sol";

contract test55 is
    Initializable,
    ERC721URIStorageUpgradeable
{
    using StringsUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _NTTIds;
    CountersUpgradeable.Counter private _tokenIds;
    // NTT type map
    mapping(uint256 => string) public _NTTNames;
    // TokenId to NTT map
    mapping(uint256 => uint256) public _NTTType;
    // Whether someone holds a specific NTT map of address to map of NTTId to boolean
    mapping(address => mapping(uint256 => bool)) public _NTTHoldings;

    /**
     * @dev Emitted when a new token type is created
     */
    event NTTCreated(string name, uint256 indexed id);

    function initialize(string memory name, string memory symbol)
        public
        initializer
    {
        __ERC721_init(name, symbol);
        __ERC721URIStorage_init();
    }

    
     // @dev Creates a new NTT type and assigns _initialSupply to an address
    function createNTT(string calldata name)
        external
       
    {
        uint256 _id = _NTTIds.current();
        _NTTIds.increment();

        _NTTNames[_id] = name;
        emit NTTCreated(name, _id);

        
    }

    /**
     * @dev Creates `amount` tokens of token type `_NTTId`, and assigns them to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function mint(
        address to,
        uint256 NTTId,
        string memory tokenURI
    ) external  {
        uint256 _newTokenId = _tokenIds.current();
        _tokenIds.increment();

        _safeMint(to, _newTokenId);
        _NTTType[_newTokenId] = NTTId;
        _setTokenURI(_newTokenId, tokenURI);
    }

    // Override transfer functions to make the NFTs non-transferrable

    /**
     * @dev See {IERC721-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        
        
    }

    /**
     * @dev See {IERC721-_afterTokenTransfer}.
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        _NTTHoldings[from][_NTTType[tokenId]] = false;
        _NTTHoldings[to][_NTTType[tokenId]] = true;
    }

    /**
     * @dev Whether someone holds a specific NTT
     */
    function NTTBadge(address owner, uint256 NTTId)
        public
        view
        virtual
        returns (bool)
    {
        return _NTTHoldings[owner][NTTId];
    }


    /**
     * @dev Returns the NTT ID for a given token
     */
    function tokenNTTId(uint256 tokenId)
        public
        view
        virtual
        returns (uint256)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: NTT ID query for nonexistent token"
        );

        return _NTTType[tokenId];
    }

    /**
     * @dev Returns the NTT name for a given token
     */
    function tokenNTTName(uint256 tokenId)
        public
        view
        virtual
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: NTT name query for nonexistent token"
        );

        return _NTTNames[_NTTType[tokenId]];
    }

    /**
     * @dev Returns the NTT ID for a given token
     */
    function NTTName(uint256 NTTId)
        public
        view
        virtual
        returns (string memory)
    {
        require(
            NTTId <= _NTTIds.current(),
            "ERC721Metadata: name query for nonexistent NTT type"
        );

        return _NTTNames[NTTId];
    }
}
