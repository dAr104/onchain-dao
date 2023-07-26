//SPDx-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @dev Interface of the Fake NFT Marketplace contract
 */
interface IFakeNFTMarketPlace {
    function purchase(uint _tokenId) external payable;

    function getPrice() external view returns (uint);

    function available(uint _tokenId) external view returns (bool);
}
