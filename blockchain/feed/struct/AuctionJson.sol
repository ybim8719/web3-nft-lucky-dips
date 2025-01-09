// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

struct AuctionJson {
    uint256 bidDuration;
    uint256 bidStep;
    string description;
    string name;
    string[] nftCollection;
    uint256 startingBid;
    string symbol;
}
