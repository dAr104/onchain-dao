// SPDX License-Identifier: MIT
pragma solidity ^0.8.18;

interface ICryptoDevsNFT {
    function balanceOf(address owner) external view returns (uint);

    function tokenOfOwnerByIndex(
        address owner,
        uint index
    ) external view returns (uint);
}
