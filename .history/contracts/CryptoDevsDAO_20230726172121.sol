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

    modifier inactiveProposalOnly(uint _indexProposal) {
        require(proposals[_indexProposal].deadline <= block.timestamp, "CryptoDevsDAO: Proposal is still active");
        require(proposals[_indexProposal].executed == false, "CryptoDevsDAO: Proposal has already been executed");
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

    function voteOnProposal(uint _indexProposal, Vote _vote)
        external
        nftHolderOnly
        activeProposalOnly(_indexProposal)
    {
        CryptoDevsDAOLibrary.Proposal storage proposal = proposals[_indexProposal];

        uint voterNftTokenId = cryptoDevsNFT.balanceOf(msg.sender);
        uint numVotes = 0;

        // Calculate how many nft's are owned by the voter and how many of them have already been used to vote
        for (uint i = 0; i < voterNftTokenId; i++) {
            uint tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(msg.sender, i);
            if (proposal.voters[tokenId] == false) {
                    numVotes++;
                    proposal.voters[tokenId] = true;
            }

        }

        // to vote you must own at least one NFT that has not been used to vote yet
        require(numVotes > 0, "CryptoDevsDAO: You have already used all your NFTs to vote");

        if (_vote == Vote.YAY) {
            proposal.yayVotes += numVotes;
        } else {
            proposal.nayVotes += numVotes;
        }
    }

    function executeProposal(uint _indexProposal) 
        external
        nftHolderOnly
        inactiveProposalOnly(_indexProposal)
    {
        CryptoDevsDAOLibrary.Proposal storage proposal = proposals[_indexProposal];

        if(proposal.yayVotes > proposal.nayVotes) {
            uint nftPrice = nftMatketplace.getPrice();
            require((address(this)).balance >= nftPrice, "CryptoDevsDAO: Not enough funds to purchase the NFT in the DAO");
            nftMatketplace.purchase{value: nftPrice}(proposal.nftTokenId);
        }   



}
