// SPDX License-Identifier: MIT
pragma solidity ^0.8.18;

library CryptoDevsDAOLibrary {
    struct Proposal {
        uint nftTokenId;
        // the unix timestamp until whitch this proposal is active. Proposal can be executed after the deadline has been exceeded
        uint deadline;
        // the number of yay and nay votes
        uint yayVotes;
        uint nayVotes;
        bool executed;
        // a mapping of CryptoDevsNFT tokenIDs to booleand indicating whether that NFT has already been used to cast a vote or not
        mapping(uint => bool) voters;
    }
}
