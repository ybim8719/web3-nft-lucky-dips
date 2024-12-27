// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

struct Auction {
    bool isPublished;
    string description;
    string symbol;
    string name;
    uint256 startingBid;
    uint256 bidStep;
    uint256 nextBidStep;
    address bestBidder;
    address deployed;
    string[] nftImageUris;
}
// LATER add validaty duration in seconds

// 7 days = 604 800
// 10 days = 864 000
