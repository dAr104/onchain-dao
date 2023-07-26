//SPDx-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @dev Interface of the Fake NFT Marketplace contract
 */
interface IFakeNFTMarketPlace {
    /**
     * @dev purchases an NFT from the FakeNFTMarketplace
     * @param _tokenId - the fake NFT token id to purchase
     */
    function purchase(uint _tokenId) external payable;

    /**
     * @dev returns the price of the NFT
     * @return the price in wei of the NFT
     */
    function getPrice() external view returns (uint);

    /**
     * @dev checks whether the given tokenId is available for purchase
     * @param _tokenId - the fake NFT token id to check
     * @return true if the NFT is available for purchase, false if not
     */
    function available(uint _tokenId) external view returns (bool);
}
