// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {Auction} from "./structs/Auction.sol";
import {NFTBooster} from "./NFTBooster.sol";
import {console} from "forge-std/Script.sol";
import {AutomationCompatibleInterface} from
    "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";

/**
 * @title NFTBoosterAuctions is a bid application of aunction selling the ownership of a set of nft designed by a unique artist (also called booster)
 * The artworks are hosted on chain, since they are svg files encoded on base 64. The particylarity of the auction is that the
 * pictures are only exposed when the final bid is achieved and final NFT contract deployed.
 * @author ybim
 * @notice After deployment of contract, a unlimited number of auction can be send by the owner of the contract
 * For more, follow instructions in the read me file or in the Contract script/DeployNFTBoosterAuction.s.sol
 */
contract NFTBoosterAuctions is AutomationCompatibleInterface {
    /*//////////////////////////////////////////////////////////////
                            ERRORS
    //////////////////////////////////////////////////////////////*/
    error NFTBoosterAuctions__OwnerOnly();
    error NFTBoosterAuctions__InvalidBiddingAmount(address caller, uint256 sentValue);
    error NFTBoosterAuctions__BidAlreadyAchieved(uint256 index);
    error NFTBoosterAuctions__BidNotOpenYet(uint256 index);
    error NFTBoosterAuctions__UnsufficientFunds(uint256 amountToSend, uint256 currentBalance);
    error NFTBoosterAuctions__CantBidWhenAlreadyBestBidder(uint256 index);
    error NFTBoosterAuctions__NoOneHasBid(uint256 index);
    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/

    event NewBid(uint256 indexed AuctionIndex, address indexed bestBidder, uint256 indexed bid);
    /*//////////////////////////////////////////////////////////////
                            STATES
    //////////////////////////////////////////////////////////////*/

    address private i_owner;
    Auction[] private s_auctions;
    uint256 private constant MEMBERSHIP_FEE = 0.01 ether;
    /*//////////////////////////////////////////////////////////////
                            MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier ownerOnly() {
        if (msg.sender != i_owner) {
            revert NFTBoosterAuctions__OwnerOnly();
        }
        _;
    }

    modifier isBiddable(uint256 i) {
        if (s_auctions[i].isPublished == false) {
            revert NFTBoosterAuctions__BidNotOpenYet(i);
        }
        // check if not already deployed
        if (s_auctions[i].deployed != address(0)) {
            revert NFTBoosterAuctions__BidAlreadyAchieved(i);
        }
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    function addAuction(
        string memory _description,
        string memory _symbol,
        string memory _name,
        uint256 _startingBid,
        uint256 _bidStep,
        string[] memory imageUris
    ) public ownerOnly {
        s_auctions.push(
            Auction(false, _description, _symbol, _name, _startingBid, _bidStep, 0, address(0), address(0), imageUris)
        );
    }

    function bidForAuction(uint256 i) public payable isBiddable(i) {
        //check if previous isn't the same as msg.sender
        if (msg.sender == s_auctions[i].bestBidder) {
            revert NFTBoosterAuctions__CantBidWhenAlreadyBestBidder(i);
        }
        //check if amount sent is ok for winning the bid
        if (msg.value != getNextBiddingPriceInWei(i)) {
            revert NFTBoosterAuctions__InvalidBiddingAmount(msg.sender, msg.value);
        }

        // Check if it has a previous bidder.
        if (s_auctions[i].bestBidder != address(0)) {
            uint256 prevBid = s_auctions[i].startingBid + (s_auctions[i].bidStep * (s_auctions[i].nextBidStep - 1));
            // then check contract balance
            if (address(this).balance < prevBid) {
                revert NFTBoosterAuctions__UnsufficientFunds(prevBid, address(this).balance);
            }
            // send back the previous bid amount to prev bidder
            (bool callSuccess,) = payable(s_auctions[i].bestBidder).call{value: prevBid}("");
            require(callSuccess, "Call failed");
        }
        s_auctions[i].bestBidder = msg.sender;
        s_auctions[i].nextBidStep++;
        emit NewBid(i, msg.sender, msg.value);
    }

    function openBid(uint256 i) public ownerOnly {
        s_auctions[i].isPublished = true;
    }

    /*//////////////////////////////////////////////////////////////
                            ORACLE AUTOMATION
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev This is the function that the Chainlink Keeper nodes call (off chain operation)
     * to look for `upkeepNeeded` to return True.
     */
    function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        // TODO Check for timestamp > overdue + has at least one bidder.
        // upkeepNeeded = (block.timestamp - s_lastTimeStamp) > INTERVAL;
        // performData = abi.encode(s_counter);
        // TODO if true, send back true and the index of the corresponding array.
        // return (upkeepNeeded, performData);
    }

    /**
     * @dev Once `checkUpkeep` is returning `true`, this function is called
     * and it decodes "performData" and uses it to end the aunction
     */
    function performUpkeep(bytes calldata performData) external override {
        // uint256 currentCounter = abi.decode(performData, (uint256));
        // (bool upkeepNeeded,) = checkUpkeep("");
    }

    // for given aunction check avialbiliy duration and pick the winner, create the ERC721 contract and mint the related nfts
    function endAuction(uint256 i) public ownerOnly isBiddable(i) {
        address winner = getBestBidder(i);
        if (winner == address(0)) {
            // no one has ever bid
            revert NFTBoosterAuctions__NoOneHasBid(i);
        }
        // TODO LATER duration time has been passed
        // create new NFT contract and store address
        NFTBooster nftBooster = new NFTBooster(
            getName(i),
            getSymbol(i),
            getAunctionDescription(i),
            getCurrentBiddingPriceInWei(i),
            getAunctionNFTLength(i),
            winner
        );
        // store contract adress in aunction
        s_auctions[i].deployed = address(nftBooster);
        // mint NFT one by one, by passing URI and bid winner
        for (uint256 j = 0; j < getAunctionNFTLength(i); j++) {
            nftBooster.mintNft(getAuctionNFT(i, j), winner);
        }
        // send the bid to the owner of this contract
        uint256 finalBidAmout = getCurrentBiddingPriceInWei(i);
        if (address(this).balance < finalBidAmout) {
            revert NFTBoosterAuctions__UnsufficientFunds(finalBidAmout, address(this).balance);
        }
        (bool callSuccess,) = payable(i_owner).call{value: finalBidAmout}("");
        require(callSuccess, "Call failed");
    }

    /*//////////////////////////////////////////////////////////////
                            PURE/ VIEWS
    //////////////////////////////////////////////////////////////*/
    function isAunctionPublished(uint256 i) public view returns (bool) {
        return s_auctions[i].isPublished;
    }

    function getName(uint256 i) public view returns (string memory) {
        return s_auctions[i].name;
    }

    function getSymbol(uint256 i) public view returns (string memory) {
        return s_auctions[i].symbol;
    }

    function getNbOfAuctions() public view returns (uint256) {
        return s_auctions.length;
    }

    function getAuctionNFT(uint256 i, uint256 j) public view returns (string memory) {
        return s_auctions[i].nftImageUris[j];
    }

    function getAunctionDescription(uint256 i) public view returns (string memory) {
        return s_auctions[i].description;
    }

    function getAunctionNFTLength(uint256 i) public view returns (uint256) {
        return s_auctions[i].nftImageUris.length;
    }

    function getStartingBid(uint256 i) public view returns (uint256) {
        return s_auctions[i].startingBid;
    }

    function getNextBiddingPriceInWei(uint256 i) public view returns (uint256) {
        return (s_auctions[i].startingBid + (s_auctions[i].bidStep * s_auctions[i].nextBidStep));
    }

    function getCurrentBiddingPriceInWei(uint256 i) public view returns (uint256) {
        return (s_auctions[i].startingBid + (s_auctions[i].bidStep * (s_auctions[i].nextBidStep - 1)));
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getBestBidder(uint256 i) public view returns (address) {
        return s_auctions[i].bestBidder;
    }
}
