// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

enum AuctionStatus {
    READY,
    OPEN,
    CLOSED,
    CANCELLED
}

struct Auction {
    AuctionStatus status;
    string description;
    string symbol;
    string name;
    uint256 startingBid;
    uint256 bidDuration;
    uint256 openingTimeStamp;
    uint256 bidStep;
    uint256 nextBidStep;
    address bestBidder;
    address deployed;
    string[] nftImageUris;
}
