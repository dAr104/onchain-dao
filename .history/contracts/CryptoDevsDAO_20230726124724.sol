// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IFakeNFTMarketPlace.sol";
import "./interfaces/ICryptoDevsNFT.sol";
import "./libraries/CryptoDevsDAOLibrary.sol/";


contract CryptoDevsDAO is Ownable {

    // mapping of proposalIDs to proposals
    mapping(uint => CryptoDevsDAOLibrary.Proposal) public proposals;

    uint public numProposals;

    //interface
    ICryptoDevsNFT cryptoDevsNFT;
    IFakeNFTMarketPlace nftMatketplace;

    //modifiers

    modifier nftHolderOnly() {
        require(cryptoDevsNFT.balanceOf(msg.sender) > 0, "CryptoDevsDAO: Only CryptoDevsNFT holders can call this function");
        _;
    }

    modifier activeProposalOnly(uint _indexProposal) {
        require(proposals[_indexProposal].deadline > block.timestamp, "CryptoDevsDAO: Proposal is not active anymore");
        _;
    }

    // enum
    enum Vote {
        YAY, // YAY = 0
        NAY // NAY = 1
    }

    /**
     @dev Constructor initializes the contract instances of interfaces. The payavle allows this constructor to accept an ETH deposit when it is being deployed.
    */
    constructor(address _nftNarketplace, address _cryptoDevsNFT) payable {
        nftMatketplace = IFakeNFTMarketPlace(_nftNarketplace);
        cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
    }

     /**
     @dev Creates a new proposal for the CryptoDevsDAO. The proposal is created with the given NFT tokenID and a deadline of 5 minutes. The proposalID is returned.
     @param _nftTokenId - the NFT tokenID to use for the proposal
     @return the proposalID of the newly created proposal
    */
    function createProposal(uint _nftTokenId)
        external
        nftHolderOnly
        returns (uint)
    {
        // check if the NFT is available for purchase
        require(nftMatketplace.available(_nftTokenId), "CryptoDevsDAO: NFT is not available for purchase");

        // create a new proposal
        CryptoDevsDAOLibrary.Proposal storage proposal = proposals[numProposals];
        proposal.nftTokenId = _nftTokenId;
        proposal.deadline = block.timestamp + 5 minutes;


        numProposals++;
        return numProposals - 1;
    }



}
