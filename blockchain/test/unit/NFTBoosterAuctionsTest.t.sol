// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";

import {Vm} from "forge-std/Vm.sol";
import {Auction, AuctionStatus} from "../../src/NFT/structs/Auction.sol";
import {NFTBoosterAuctions} from "../../src/NFT/NFTBoosterAuctions.sol";
import {NFTBooster} from "../../src/NFT/NFTBooster.sol";
import {DeployNFTBoosterAuctions} from "../../script/NFT/DeployNFTBoosterAuctions.s.sol";

contract NFTBoosterAuctionsTest is Test {
    /*//////////////////////////////////////////////////////////////
                        ACCOUNTS
    //////////////////////////////////////////////////////////////*/
    uint256 constant STARTING_BALANCE = 10 ether;
    address user1 = makeAddr("jeanmi");
    address user2 = makeAddr("philippe");

    /*//////////////////////////////////////////////////////////////
                        DEFAULT INJECTED MOCKED AUNCTION 
    //////////////////////////////////////////////////////////////*/
    string constant DEFAULT_MOCK_NAME = "JeanMiMock";
    string constant DEFAULT_MOCK_SYMBOL = "MOCK";
    uint256 constant DEFAULT_MOCK_STARTINGBID = 2500000000000000; // 2.5e15 wei or / 0.0025eth
    uint256 constant DEFAULT_MOCK_BIDSTEP = 10000000000000;
    uint256 constant DEFAULT_MOCK_BID_DURATION = 259200;
    uint256 constant DEFAULT_MOCK_IMAGE_URI_LENGTH = 4;
    uint256 constant DEFAULT_MOCK_NB_OF_AUCTIONS = 1;
    uint256 constant DEFAULT_MOCK_INDEX = 0;
    string constant DEFAULT_MOCK_DESCRIPTION = "A nice collection from Jean Michel Mock";
    // svg encoded on CLI
    string constant MOCK_IMAGE_URI1 =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PgoKPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyBmaWxsPSIjMDAwMDAwIiB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA1MTIgNTEyIiB2ZXJzaW9uPSIxLjEiIHhtbDpzcGFjZT0icHJlc2VydmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPgoKPGcgaWQ9ImdpZnRfYm94LWJveF8taGVhcnQtbG92ZS12YWxlbnRpbmUiPgoKPHBhdGggZD0iTTQwOCwxNjBoLTY0YzE1LjU1LTAuMDIxLDI4LjQ4My0xMi43MTksMjguNTA0LTI4LjI2OWMwLjAyMS0xNS41NS0xMi41NjgtMjguMTM5LTI4LjExOC0yOC4xMTggICBjMC4wMjMtMTcuNDg2LTE1LjktMzEuMjI4LTM0LjA0OC0yNy41MDRDMjk3LjEyNCw3OC44MiwyODgsOTEuMDg1LDI4OCwxMDQuNTc1djUuNjY3Yy00LjI1Ni0zLjgzOC05LjgzMS02LjI0Mi0xNi02LjI0MmgtMzIgICBjLTYuMTY5LDAtMTEuNzQ0LDIuNDA0LTE2LDYuMjQydi01LjY2N2MwLTEzLjQ5MS05LjEyNC0yNS43NTUtMjIuMzM5LTI4LjQ2N2MtMTguMTQ4LTMuNzI0LTM0LjA3MSwxMC4wMTgtMzQuMDQ4LDI3LjUwNCAgIGMtMTUuNTQ5LTAuMDIxLTI4LjEzOCwxMi41NjgtMjguMTE4LDI4LjExOEMxMzkuNTE3LDE0Ny4yODEsMTUyLjQ1LDE1OS45NzksMTY4LDE2MGgtNjRjLTE3LjY3MywwLTMyLDE0LjMyNy0zMiwzMnY4ICAgYzAsMTcuNjczLDE0LjMyNywzMiwzMiwzMmg5NnYxNkg5NnYxNjEuMjhjMCwxNi45NjYsMTMuNzU0LDMwLjcyLDMwLjcyLDMwLjcySDIwMGM4LjgzNywwLDE2LTcuMTYzLDE2LTE2VjE2OGg4MHYyNTYgICBjMCw4LjgzNyw3LjE2MywxNiwxNiwxNmg3My4yOGMxNi45NjYsMCwzMC43Mi0xMy43NTQsMzAuNzItMzAuNzJWMjQ4SDMxMnYtMTZoOTZjMTcuNjczLDAsMzItMTQuMzI3LDMyLTMydi04ICAgQzQ0MCwxNzQuMzI3LDQyNS42NzMsMTYwLDQwOCwxNjB6IE0yMzIsMTUydi0yNGMwLTQuNDEsMy41ODYtOCw4LThoMzJjNC40MTQsMCw4LDMuNTksOCw4djI0SDIzMnoiLz4KCjwvZz4KCjxnIGlkPSJMYXllcl8xIi8+Cgo8L3N2Zz4=";

    /*//////////////////////////////////////////////////////////////
                    ADDITIONAL MOCKED AUNCTION for unit tests
    //////////////////////////////////////////////////////////////*/
    string constant ADDITIONNAL_MOCK_DESCRIPTION = "description of lucky Dip #2";
    string constant ADDITIONNAL_MOCK_NAME = "Mock2";
    string constant ADDITIONNAL_MOCK_SYMBOL = "MK2";
    uint256 constant ADDITIONNAL_MOCK_STARTINGBID = 34000000000;
    uint256 constant ADDITIONNAL_MOCK_BID_DURATION = 3600;
    uint256 constant ADDITIONNAL_MOCK_BIDSTEP = 200000000;
    string constant ADDITIONNAL_MOCK_IMAGE_URI1 =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PgoKPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyBmaWxsPSIjMDAwMDAwIiB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA1MTIgNTEyIiB2ZXJzaW9uPSIxLjEiIHhtbDpzcGFjZT0icHJlc2VydmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPgoKPGcgaWQ9ImdpZnRfYm94LWJveF8taGVhcnQtbG92ZS12YWxlbnRpbmUiPgoKPHBhdGggZD0iTTQwOCwxNjBoLTY0YzE1LjU1LTAuMDIxLDI4LjQ4My0xMi43MTksMjguNTA0LTI4LjI2OWMwLjAyMS0xNS41NS0xMi41NjgtMjguMTM5LTI4LjExOC0yOC4xMTggICBjMC4wMjMtMTcuNDg2LTE1LjktMzEuMjI4LTM0LjA0OC0yNy41MDRDMjk3LjEyNCw3OC44MiwyODgsOTEuMDg1LDI4OCwxMDQuNTc1djUuNjY3Yy00LjI1Ni0zLjgzOC05LjgzMS02LjI0Mi0xNi02LjI0MmgtMzIgICBjLTYuMTY5LDAtMTEuNzQ0LDIuNDA0LTE2LDYuMjQydi01LjY2N2MwLTEzLjQ5MS05LjEyNC0yNS43NTUtMjIuMzM5LTI4LjQ2N2MtMTguMTQ4LTMuNzI0LTM0LjA3MSwxMC4wMTgtMzQuMDQ4LDI3LjUwNCAgIGMtMTUuNTQ5LTAuMDIxLTI4LjEzOCwxMi41NjgtMjguMTE4LDI4LjExOEMxMzkuNTE3LDE0Ny4yODEsMTUyLjQ1LDE1OS45NzksMTY4LDE2MGgtNjRjLTE3LjY3MywwLTMyLDE0LjMyNy0zMiwzMnY4ICAgYzAsMTcuNjczLDE0LjMyNywzMiwzMiwzMmg5NnYxNkg5NnYxNjEuMjhjMCwxNi45NjYsMTMuNzU0LDMwLjcyLDMwLjcyLDMwLjcySDIwMGM4LjgzNywwLDE2LTcuMTYzLDE2LTE2VjE2OGg4MHYyNTYgICBjMCw4LjgzNyw3LjE2MywxNiwxNiwxNmg3My4yOGMxNi45NjYsMCwzMC43Mi0xMy43NTQsMzAuNzItMzAuNzJWMjQ4SDMxMnYtMTZoOTZjMTcuNjczLDAsMzItMTQuMzI3LDMyLTMydi04ICAgQzQ0MCwxNzQuMzI3LDQyNS42NzMsMTYwLDQwOCwxNjB6IE0yMzIsMTUydi0yNGMwLTQuNDEsMy41ODYtOCw4LThoMzJjNC40MTQsMCw4LDMuNTksOCw4djI0SDIzMnoiLz4KCjwvZz4KCjxnIGlkPSJMYXllcl8xIi8+Cgo8L3N2Zz4=";
    uint256 constant ADDITIONNAL_MOCK_IMAGE_URI_LENGTH = 1;
    uint256 constant ADDITIONNAL_MOCK_NB_OF_AUCTIONS = 2;
    uint256 constant ADDITIONNAL_MOCK_INDEX = 1;

    /*//////////////////////////////////////////////////////////////
                                STATES
    //////////////////////////////////////////////////////////////*/
    string[] s_tmpImageUris;
    NFTBoosterAuctions public s_nftBoosterAuctions;
    NFTBooster public s_nftBooster;
    uint256 s_auctionsInitialBalance;

    function setUp() external {
        DeployNFTBoosterAuctions deployer = new DeployNFTBoosterAuctions();
        s_nftBoosterAuctions = deployer.runMocked(msg.sender);
        s_auctionsInitialBalance = address(s_nftBoosterAuctions).balance;
        vm.deal(user1, STARTING_BALANCE);
        vm.deal(user2, STARTING_BALANCE);
    }

    /*//////////////////////////////////////////////////////////////
                            MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier initialBidIsOpen() {
        vm.prank(msg.sender);
        s_nftBoosterAuctions.openAuction(DEFAULT_MOCK_INDEX);
        assertEq(s_nftBoosterAuctions.isAunctionPublished(DEFAULT_MOCK_INDEX), true);
        _;
    }

    modifier oneBidWasMadeByUser1() {
        vm.prank(msg.sender);
        s_nftBoosterAuctions.openAuction(DEFAULT_MOCK_INDEX);
        assertEq(s_nftBoosterAuctions.isAunctionPublished(DEFAULT_MOCK_INDEX), true);
        vm.startPrank(user1);
        s_nftBoosterAuctions.bidForAuction{value: s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX)}(
            DEFAULT_MOCK_INDEX
        );
        vm.stopPrank();
        assertEq(s_nftBoosterAuctions.getBestBidder(DEFAULT_MOCK_INDEX), user1);
        _;
    }

    modifier initialBidEnded() {
        vm.prank(msg.sender);
        s_nftBoosterAuctions.openAuction(DEFAULT_MOCK_INDEX);
        assertEq(s_nftBoosterAuctions.isAunctionPublished(DEFAULT_MOCK_INDEX), true);
        vm.startPrank(user1);
        s_nftBoosterAuctions.bidForAuction{value: s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX)}(
            DEFAULT_MOCK_INDEX
        );
        vm.stopPrank();
        assertEq(s_nftBoosterAuctions.getBestBidder(DEFAULT_MOCK_INDEX), user1);
        vm.warp(block.timestamp + DEFAULT_MOCK_BID_DURATION + 1);
        vm.roll(block.number + 1);
        vm.prank(msg.sender);
        s_nftBoosterAuctions.checkAndEndAuction(DEFAULT_MOCK_INDEX);
        address deployed = s_nftBoosterAuctions.getDeployed(DEFAULT_MOCK_INDEX);
        s_nftBooster = NFTBooster(deployed);
        _;
    }

    modifier skipFork() {
        // anvil only
        if (block.chainid != 31337) {
            return;
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                            ADD AUCTION
    //////////////////////////////////////////////////////////////*/
    function testAunctionAddingWorks() public view {
        assertEq(s_nftBoosterAuctions.getAunctionNFTLength(DEFAULT_MOCK_INDEX), DEFAULT_MOCK_IMAGE_URI_LENGTH);
        assertEq(s_nftBoosterAuctions.isAunctionPublished(DEFAULT_MOCK_INDEX), false);
        assertEq(s_nftBoosterAuctions.getNbOfAuctions(), DEFAULT_MOCK_NB_OF_AUCTIONS);
        assertEq(s_nftBoosterAuctions.getAunctionDescription(DEFAULT_MOCK_INDEX), DEFAULT_MOCK_DESCRIPTION);
        assertEq(s_nftBoosterAuctions.getStartingBid(DEFAULT_MOCK_INDEX), DEFAULT_MOCK_STARTINGBID);
        assertEq(s_nftBoosterAuctions.getBidDuration(DEFAULT_MOCK_INDEX), DEFAULT_MOCK_BID_DURATION);
        assertEq(
            s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX),
            (DEFAULT_MOCK_STARTINGBID + (0 * DEFAULT_MOCK_BIDSTEP))
        );
        // TODO encoding of svg seems to behave differently on each machine (base64 -i <path-to-svg-file>)
        //assertEq(luckyDip.getAunctionNFT(0, 0), MOCK_IMAGE_URI1);
    }

    function testMemberCantAddAunction() public {
        s_tmpImageUris = new string[](0);
        s_tmpImageUris.push("fake uri which will fail");
        s_tmpImageUris.push("fake uri which will fail2");
        vm.prank(user1);
        vm.expectRevert();

        s_nftBoosterAuctions.addAuction(
            "fake description", "fake symbol", "fake _name", 10000000000, 1000000000, 36000, s_tmpImageUris
        );
    }

    function testOwnerCanAddAunction() public {
        s_tmpImageUris = new string[](0);
        s_tmpImageUris.push(ADDITIONNAL_MOCK_IMAGE_URI1);
        vm.prank(msg.sender);
        s_nftBoosterAuctions.addAuction(
            ADDITIONNAL_MOCK_DESCRIPTION,
            ADDITIONNAL_MOCK_SYMBOL,
            ADDITIONNAL_MOCK_NAME,
            ADDITIONNAL_MOCK_STARTINGBID,
            ADDITIONNAL_MOCK_BID_DURATION,
            ADDITIONNAL_MOCK_BIDSTEP,
            s_tmpImageUris
        );
        assertEq(s_nftBoosterAuctions.getNbOfAuctions(), ADDITIONNAL_MOCK_NB_OF_AUCTIONS);
        assertEq(s_nftBoosterAuctions.getAunctionNFTLength(1), ADDITIONNAL_MOCK_IMAGE_URI_LENGTH);
        assertEq(s_nftBoosterAuctions.getAunctionDescription(1), ADDITIONNAL_MOCK_DESCRIPTION);
        assertEq(s_nftBoosterAuctions.getStartingBid(1), ADDITIONNAL_MOCK_STARTINGBID);
        assertEq(s_nftBoosterAuctions.getNextBiddingPriceInWei(1), ADDITIONNAL_MOCK_STARTINGBID);
        assertEq(s_nftBoosterAuctions.isAunctionPublished(1), false);
    }

    /*//////////////////////////////////////////////////////////////
                            AUCTION OPENING
    //////////////////////////////////////////////////////////////*/
    function testOwnerCanOpenBid() public {
        assertEq(s_nftBoosterAuctions.isAunctionPublished(DEFAULT_MOCK_INDEX), false);
        vm.prank(msg.sender);
        s_nftBoosterAuctions.openAuction(DEFAULT_MOCK_INDEX);
        assertEq(s_nftBoosterAuctions.isAunctionPublished(DEFAULT_MOCK_INDEX), true);
    }

    function testUserCantOpenBid() public {
        assertEq(s_nftBoosterAuctions.isAunctionPublished(DEFAULT_MOCK_INDEX), false);
        vm.prank(user1);
        vm.expectRevert(NFTBoosterAuctions.NFTBoosterAuctions__OwnerOnly.selector);
        s_nftBoosterAuctions.openAuction(DEFAULT_MOCK_INDEX);
    }

    function testCantOpenBidIfAlreadyDeployed() public initialBidEnded {
        vm.prank(msg.sender);
        vm.expectRevert();
        s_nftBoosterAuctions.openAuction(DEFAULT_MOCK_INDEX);
    }

    /*//////////////////////////////////////////////////////////////
                            CANCEL AUNCTION
    //////////////////////////////////////////////////////////////*/
    function testCantCancelIfNotOwner() public {
        vm.prank(user1);
        vm.expectRevert(NFTBoosterAuctions.NFTBoosterAuctions__OwnerOnly.selector);
        s_nftBoosterAuctions.cancelAunction(DEFAULT_MOCK_INDEX);
    }

    function testCanCancelIfStatusIsReady() public initialBidIsOpen {
        vm.prank(msg.sender);
        s_nftBoosterAuctions.cancelAunction(DEFAULT_MOCK_INDEX);
        assertEq(s_nftBoosterAuctions.getStatus(DEFAULT_MOCK_INDEX) == AuctionStatus.CLOSED, true);
    }

    function testCantCancelIfAlreadyClosed() public initialBidIsOpen {
        vm.startPrank(msg.sender);
        s_nftBoosterAuctions.cancelAunction(DEFAULT_MOCK_INDEX);
        vm.expectRevert(
            abi.encodeWithSelector(
                NFTBoosterAuctions.NFTBoosterAuctions__CantClosedAuction.selector, DEFAULT_MOCK_INDEX
            )
        );
        s_nftBoosterAuctions.cancelAunction(DEFAULT_MOCK_INDEX);
        vm.stopPrank();
    }

    function testCantCancelIfAuctionHasBidder() public oneBidWasMadeByUser1 {
        vm.prank(msg.sender);
        vm.expectRevert(
            abi.encodeWithSelector(
                NFTBoosterAuctions.NFTBoosterAuctions__CantClosedAuction.selector, DEFAULT_MOCK_INDEX
            )
        );
        s_nftBoosterAuctions.cancelAunction(DEFAULT_MOCK_INDEX);
    }

    /*//////////////////////////////////////////////////////////////
                            BID ON AUCTION
    //////////////////////////////////////////////////////////////*/
    function testCanBidIfAllOk() public initialBidIsOpen {
        uint256 initialBalance = address(s_nftBoosterAuctions).balance;
        vm.startPrank(user1);
        uint256 sendValue = s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX);
        s_nftBoosterAuctions.bidForAuction{value: sendValue}(DEFAULT_MOCK_INDEX);
        vm.stopPrank();
        assertEq(
            s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX),
            (DEFAULT_MOCK_STARTINGBID + (1 * DEFAULT_MOCK_BIDSTEP))
        );
        assertEq(s_nftBoosterAuctions.getBestBidder(DEFAULT_MOCK_INDEX), user1);
        assertEq(address(user1).balance, STARTING_BALANCE - sendValue);
        assertEq(
            address(s_nftBoosterAuctions).balance,
            initialBalance + s_nftBoosterAuctions.getStartingBid(DEFAULT_MOCK_INDEX)
        );
    }

    function testPreviousBidderGetHisMoneyBack() public oneBidWasMadeByUser1 {
        uint256 initialBalance = address(s_nftBoosterAuctions).balance;
        uint256 sendValue = s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX);
        vm.prank(user2);
        s_nftBoosterAuctions.bidForAuction{value: sendValue}(DEFAULT_MOCK_INDEX);
        assertEq(address(user1).balance, STARTING_BALANCE);
        assertEq(address(user2).balance, STARTING_BALANCE - sendValue);
        assertEq(
            address(s_nftBoosterAuctions).balance, initialBalance + s_nftBoosterAuctions.getBidStep(DEFAULT_MOCK_INDEX)
        );
    }

    function testCantBidWithInvalidAmount() public initialBidIsOpen {
        vm.startPrank(user1);
        uint256 wrongValue = s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX) + 1;
        vm.expectRevert(
            abi.encodeWithSelector(
                NFTBoosterAuctions.NFTBoosterAuctions__InvalidBiddingAmount.selector, user1, wrongValue
            )
        );
        s_nftBoosterAuctions.bidForAuction{value: wrongValue}(DEFAULT_MOCK_INDEX);
        vm.stopPrank();
    }

    function testCantBidTwoTimesInARow() public initialBidIsOpen {
        vm.startPrank(user1);
        uint256 initialBiddingPrice = s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX);
        s_nftBoosterAuctions.bidForAuction{value: initialBiddingPrice}(DEFAULT_MOCK_INDEX);
        assertEq(s_nftBoosterAuctions.getBestBidder(DEFAULT_MOCK_INDEX), user1);
        uint256 currentBuiddingPrice = s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX);
        assertNotEq(currentBuiddingPrice, initialBiddingPrice);
        vm.expectRevert(
            abi.encodeWithSelector(
                NFTBoosterAuctions.NFTBoosterAuctions__CantBidWhenAlreadyBestBidder.selector, DEFAULT_MOCK_INDEX
            )
        );
        s_nftBoosterAuctions.bidForAuction{value: currentBuiddingPrice}(DEFAULT_MOCK_INDEX);
        vm.stopPrank();
    }

    function testCantBidIfNotOpen() public {
        vm.startPrank(user1);
        // isolating this variable is mandatory because: https://ethereum.stackexchange.com/questions/158768/vm-expectrevert-is-not-working-as-expected-in-foundry
        uint256 sendValue = s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX);
        vm.expectRevert(
            abi.encodeWithSelector(NFTBoosterAuctions.NFTBoosterAuctions__BidNotOpen.selector, DEFAULT_MOCK_INDEX)
        );
        s_nftBoosterAuctions.bidForAuction{value: sendValue}(DEFAULT_MOCK_INDEX);
        vm.stopPrank();
    }

    function testCantBidIfAlreadyDeployed() public initialBidEnded {
        vm.startPrank(user1);
        // isolating this variable is mandatory because: https://ethereum.stackexchange.com/questions/158768/vm-expectrevert-is-not-working-as-expected-in-foundry
        uint256 sendValue = s_nftBoosterAuctions.getNextBiddingPriceInWei(DEFAULT_MOCK_INDEX);
        vm.expectRevert(
            abi.encodeWithSelector(
                NFTBoosterAuctions.NFTBoosterAuctions__BidAlreadyAchieved.selector, DEFAULT_MOCK_INDEX
            )
        );
        s_nftBoosterAuctions.bidForAuction{value: sendValue}(DEFAULT_MOCK_INDEX);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        CHECK AND END BID (by owner)
    //////////////////////////////////////////////////////////////*/
    function testEndingABidWorks() public initialBidEnded {
        testBidEndingWorksTotally();
    }

    function testCantEndABidIfNotOpen() public {
        vm.prank(msg.sender);
        vm.expectRevert(
            abi.encodeWithSelector(NFTBoosterAuctions.NFTBoosterAuctions__BidNotOpen.selector, DEFAULT_MOCK_INDEX)
        );
        s_nftBoosterAuctions.checkAndEndAuction(DEFAULT_MOCK_INDEX);
    }

    function testCantEndBidIfNotOwner() public oneBidWasMadeByUser1 {
        vm.warp(block.timestamp + DEFAULT_MOCK_BID_DURATION + 1);
        vm.roll(block.number + 1);
        vm.prank(user1);
        vm.expectRevert(NFTBoosterAuctions.NFTBoosterAuctions__OwnerOnly.selector);
        s_nftBoosterAuctions.checkAndEndAuction(DEFAULT_MOCK_INDEX);
    }

    // todo: cant end bid because no one ever participated
    function testCantEndABidWithoutBidders() public initialBidIsOpen {
        vm.warp(block.timestamp + DEFAULT_MOCK_BID_DURATION + 1);
        vm.roll(block.number + 1);
        vm.prank(msg.sender);
        vm.expectRevert(
            abi.encodeWithSelector(NFTBoosterAuctions.NFTBoosterAuctions__NoOneHasBid.selector, DEFAULT_MOCK_INDEX)
        );
        s_nftBoosterAuctions.checkAndEndAuction(DEFAULT_MOCK_INDEX);
    }

    function testCantEndABidIfDurationTimeNotPassed() public oneBidWasMadeByUser1 {
        vm.prank(msg.sender);
        vm.expectRevert(
            abi.encodeWithSelector(
                NFTBoosterAuctions.NFTBoosterAuctions__ExpiryDateNotReachedYet.selector, DEFAULT_MOCK_INDEX
            )
        );
        s_nftBoosterAuctions.checkAndEndAuction(DEFAULT_MOCK_INDEX);
    }

    /*//////////////////////////////////////////////////////////////
                            CHECK UPKEEP 
    //////////////////////////////////////////////////////////////*/
    function testCheckUpkeepReturnsTrue() public oneBidWasMadeByUser1 {
        vm.warp(block.timestamp + DEFAULT_MOCK_BID_DURATION + 1);
        vm.roll(block.number + 1);
        vm.prank(msg.sender);
        (bool upkeepNeeded, bytes memory indexToEnd) = s_nftBoosterAuctions.checkUpkeep("");
        assertEq(upkeepNeeded, true);
        uint256 decodedIndex = abi.decode(indexToEnd, (uint256));
        assertEq(decodedIndex, DEFAULT_MOCK_INDEX);
    }

    function testCheckUpkeepReturnsFalseIfNotOpen() public initialBidEnded {
        vm.prank(user1);
        (bool upkeepNeeded,) = s_nftBoosterAuctions.checkUpkeep("");
        assertEq(upkeepNeeded, false);
    }

    function testCheckUpkeepReturnsFalseIfDurationTimeNotPassed() public oneBidWasMadeByUser1 {
        vm.prank(user1);
        (bool upkeepNeeded,) = s_nftBoosterAuctions.checkUpkeep("");
        assertEq(upkeepNeeded, false);
    }

    function testCheckUpkeepReturnsFalseIfNotBidders() public initialBidIsOpen {
        vm.warp(block.timestamp + DEFAULT_MOCK_BID_DURATION + 1);
        vm.roll(block.number + 1);
        vm.prank(user1);
        (bool upkeepNeeded,) = s_nftBoosterAuctions.checkUpkeep("");
        assertEq(upkeepNeeded, false);
    }

    /*//////////////////////////////////////////////////////////////
                            PERFORM UPKEEP 
    //////////////////////////////////////////////////////////////*/
    function testPerformWorks() public oneBidWasMadeByUser1 {
        vm.warp(block.timestamp + DEFAULT_MOCK_BID_DURATION + 1);
        vm.roll(block.number + 1);
        vm.prank(user1);
        s_nftBoosterAuctions.performUpkeep(abi.encode(DEFAULT_MOCK_INDEX));
        address deployed = s_nftBoosterAuctions.getDeployed(DEFAULT_MOCK_INDEX);
        s_nftBooster = NFTBooster(deployed);
        testBidEndingWorksTotally();
    }

    function testPerformRevertIfDurationTimeNotPassed() public oneBidWasMadeByUser1 {
        vm.prank(user1);
        vm.expectRevert(NFTBoosterAuctions.NFTBoosterAuctions__UpkeepNotNeeded.selector);
        s_nftBoosterAuctions.performUpkeep(abi.encode(DEFAULT_MOCK_INDEX));
    }

    function testPerformRevertIfNotBidders() public initialBidIsOpen {
        vm.warp(block.timestamp + DEFAULT_MOCK_BID_DURATION + 1);
        vm.roll(block.number + 1);
        vm.prank(user1);
        vm.expectRevert(NFTBoosterAuctions.NFTBoosterAuctions__UpkeepNotNeeded.selector);
        s_nftBoosterAuctions.performUpkeep(abi.encode(DEFAULT_MOCK_INDEX));
    }

    function testPerformRevertIfNotOpen() public {
        vm.prank(user1);
        vm.expectRevert(NFTBoosterAuctions.NFTBoosterAuctions__UpkeepNotNeeded.selector);
        s_nftBoosterAuctions.performUpkeep(abi.encode(DEFAULT_MOCK_INDEX));
    }

    function testBidEndingWorksTotally() private view {
        uint256 finalBid = s_nftBoosterAuctions.getCurrentBiddingPriceInWei(DEFAULT_MOCK_INDEX);
        //auctions
        assertEq(s_nftBoosterAuctions.getDeployed(DEFAULT_MOCK_INDEX) != address(0), true);
        assertEq(s_nftBoosterAuctions.getStatus(DEFAULT_MOCK_INDEX) == AuctionStatus.CLOSED, true);
        //booster
        assertEq(s_nftBooster.getSymbol(), DEFAULT_MOCK_SYMBOL);
        assertEq(s_nftBooster.getDescription(), DEFAULT_MOCK_DESCRIPTION);
        assertEq(s_nftBooster.getName(), DEFAULT_MOCK_NAME);
        assertEq(s_nftBooster.getFinalBid(), finalBid);
        assertEq(s_nftBooster.getTokenCounter(), DEFAULT_MOCK_IMAGE_URI_LENGTH);
        for (uint256 i = 0; i < DEFAULT_MOCK_IMAGE_URI_LENGTH; i++) {
            assertEq(s_nftBooster.ownerOf(i), s_nftBoosterAuctions.getBestBidder(DEFAULT_MOCK_INDEX));
        }
        // balance
        assertEq(address(s_nftBoosterAuctions).balance, s_auctionsInitialBalance);
    }
}
