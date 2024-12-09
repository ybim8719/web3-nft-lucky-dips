// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

struct LuckyDip {
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
