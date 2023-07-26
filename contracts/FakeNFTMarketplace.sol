//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FakeNFTMarketplace {
    // mantaint a mapping of Fake TokenId to Owner addresses
    mapping(uint => address) public tokens;

    uint constant nftPrice = 0.1 ether;

    /**
     * @dev accepts ETH and marks the owner of the given tokenId as the caller address
     * @param _tokenId - the fake NFT token id to purchase
     */
    function purchase(uint _tokenId) external payable {
        require(msg.value == nftPrice, "Price of this NTF is 0.1 ehter");
        tokens[_tokenId] = msg.sender;
    }

    /**
     * @dev return price of the NFT
     */
    function getPrice() external view returns (uint) {
        return nftPrice;
    }

    /**
     * @dev checks whether the given tokenId is available for purchase
     * @param _tokenId - the fake NFT token id to check
     */
    function available(uint _tokenId) external view returns (bool) {
        return tokens[_tokenId] == address(0);
    }
}
