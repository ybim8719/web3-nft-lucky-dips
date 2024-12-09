// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {LuckyDip} from "../../src/NFT/structs/LuckyDip.sol";
import {NFTLuckyDip} from "../../src/NFT/NFTLuckyDip.sol";
import {DeployNFTLuckyDip} from "../../script/NFT/DeployLuckyDip.s.sol";

contract NftLuckyDipTest is Test {
    /**
     * USERS
     */
    uint256 constant STARTING_BALANCE = 10 ether;
    address user1 = makeAddr("cochonou");
    address user2 = makeAddr("philippe");
    /**
     * DEFAULT MOCKED LUCKY DIP
     */
    string constant DEFAULT_MOCK_NAME = "JeanMiMock";
    uint256 constant DEFAULT_MOCK_STARTINGBID = 2500000000000000;
    uint256 constant DEFAULT_MOCK_BIDSTEP = 10000000000000;
    // svg encoded on CLI
    string constant MOCK_IMAGE_URI1 =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PgoKPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyBmaWxsPSIjMDAwMDAwIiB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA1MTIgNTEyIiB2ZXJzaW9uPSIxLjEiIHhtbDpzcGFjZT0icHJlc2VydmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPgoKPGcgaWQ9ImdpZnRfYm94LWJveF8taGVhcnQtbG92ZS12YWxlbnRpbmUiPgoKPHBhdGggZD0iTTQwOCwxNjBoLTY0YzE1LjU1LTAuMDIxLDI4LjQ4My0xMi43MTksMjguNTA0LTI4LjI2OWMwLjAyMS0xNS41NS0xMi41NjgtMjguMTM5LTI4LjExOC0yOC4xMTggICBjMC4wMjMtMTcuNDg2LTE1LjktMzEuMjI4LTM0LjA0OC0yNy41MDRDMjk3LjEyNCw3OC44MiwyODgsOTEuMDg1LDI4OCwxMDQuNTc1djUuNjY3Yy00LjI1Ni0zLjgzOC05LjgzMS02LjI0Mi0xNi02LjI0MmgtMzIgICBjLTYuMTY5LDAtMTEuNzQ0LDIuNDA0LTE2LDYuMjQydi01LjY2N2MwLTEzLjQ5MS05LjEyNC0yNS43NTUtMjIuMzM5LTI4LjQ2N2MtMTguMTQ4LTMuNzI0LTM0LjA3MSwxMC4wMTgtMzQuMDQ4LDI3LjUwNCAgIGMtMTUuNTQ5LTAuMDIxLTI4LjEzOCwxMi41NjgtMjguMTE4LDI4LjExOEMxMzkuNTE3LDE0Ny4yODEsMTUyLjQ1LDE1OS45NzksMTY4LDE2MGgtNjRjLTE3LjY3MywwLTMyLDE0LjMyNy0zMiwzMnY4ICAgYzAsMTcuNjczLDE0LjMyNywzMiwzMiwzMmg5NnYxNkg5NnYxNjEuMjhjMCwxNi45NjYsMTMuNzU0LDMwLjcyLDMwLjcyLDMwLjcySDIwMGM4LjgzNywwLDE2LTcuMTYzLDE2LTE2VjE2OGg4MHYyNTYgICBjMCw4LjgzNyw3LjE2MywxNiwxNiwxNmg3My4yOGMxNi45NjYsMCwzMC43Mi0xMy43NTQsMzAuNzItMzAuNzJWMjQ4SDMxMnYtMTZoOTZjMTcuNjczLDAsMzItMTQuMzI3LDMyLTMydi04ICAgQzQ0MCwxNzQuMzI3LDQyNS42NzMsMTYwLDQwOCwxNjB6IE0yMzIsMTUydi0yNGMwLTQuNDEsMy41ODYtOCw4LThoMzJjNC40MTQsMCw4LDMuNTksOCw4djI0SDIzMnoiLz4KCjwvZz4KCjxnIGlkPSJMYXllcl8xIi8+Cgo8L3N2Zz4=";
    uint256 constant DEFAULT_MOCK_IMAGE_URI_LENGTH = 4;
    uint256 constant DEFAULT_MOCK_NB_OF_LUCKY_DIPS = 1;
    string constant DEFAULT_MOCK_DESCRIPTION = "A nice collection from Jean Michel Mock";
    /**
     * MOCKED LUCKY DIP TO ADD in test
     */
    string constant ADDITIONNAL_MOCK_DESCRIPTION = "description of lucky Dip #2";
    string constant ADDITIONNAL_MOCK_NAME = "Mock2";
    string constant ADDITIONNAL_MOCK_SYMBOL = "MK2";
    uint256 constant ADDITIONNAL_MOCK_STARTINGBID = 34000000000;
    uint256 constant ADDITIONNAL_MOCK_BIDSTEP = 200000000;
    string constant ADDITIONNAL_MOCK_IMAGE_URI1 =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PgoKPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyBmaWxsPSIjMDAwMDAwIiB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA1MTIgNTEyIiB2ZXJzaW9uPSIxLjEiIHhtbDpzcGFjZT0icHJlc2VydmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPgoKPGcgaWQ9ImdpZnRfYm94LWJveF8taGVhcnQtbG92ZS12YWxlbnRpbmUiPgoKPHBhdGggZD0iTTQwOCwxNjBoLTY0YzE1LjU1LTAuMDIxLDI4LjQ4My0xMi43MTksMjguNTA0LTI4LjI2OWMwLjAyMS0xNS41NS0xMi41NjgtMjguMTM5LTI4LjExOC0yOC4xMTggICBjMC4wMjMtMTcuNDg2LTE1LjktMzEuMjI4LTM0LjA0OC0yNy41MDRDMjk3LjEyNCw3OC44MiwyODgsOTEuMDg1LDI4OCwxMDQuNTc1djUuNjY3Yy00LjI1Ni0zLjgzOC05LjgzMS02LjI0Mi0xNi02LjI0MmgtMzIgICBjLTYuMTY5LDAtMTEuNzQ0LDIuNDA0LTE2LDYuMjQydi01LjY2N2MwLTEzLjQ5MS05LjEyNC0yNS43NTUtMjIuMzM5LTI4LjQ2N2MtMTguMTQ4LTMuNzI0LTM0LjA3MSwxMC4wMTgtMzQuMDQ4LDI3LjUwNCAgIGMtMTUuNTQ5LTAuMDIxLTI4LjEzOCwxMi41NjgtMjguMTE4LDI4LjExOEMxMzkuNTE3LDE0Ny4yODEsMTUyLjQ1LDE1OS45NzksMTY4LDE2MGgtNjRjLTE3LjY3MywwLTMyLDE0LjMyNy0zMiwzMnY4ICAgYzAsMTcuNjczLDE0LjMyNywzMiwzMiwzMmg5NnYxNkg5NnYxNjEuMjhjMCwxNi45NjYsMTMuNzU0LDMwLjcyLDMwLjcyLDMwLjcySDIwMGM4LjgzNywwLDE2LTcuMTYzLDE2LTE2VjE2OGg4MHYyNTYgICBjMCw4LjgzNyw3LjE2MywxNiwxNiwxNmg3My4yOGMxNi45NjYsMCwzMC43Mi0xMy43NTQsMzAuNzItMzAuNzJWMjQ4SDMxMnYtMTZoOTZjMTcuNjczLDAsMzItMTQuMzI3LDMyLTMydi04ICAgQzQ0MCwxNzQuMzI3LDQyNS42NzMsMTYwLDQwOCwxNjB6IE0yMzIsMTUydi0yNGMwLTQuNDEsMy41ODYtOCw4LThoMzJjNC40MTQsMCw4LDMuNTksOCw4djI0SDIzMnoiLz4KCjwvZz4KCjxnIGlkPSJMYXllcl8xIi8+Cgo8L3N2Zz4=";
    uint256 constant ADDITIONNAL_MOCK_IMAGE_URI_LENGTH = 1;
    uint256 constant ADDITIONNAL_MOCK_NB_OF_LUCKY_DIPS = 2;
    string[] s_tmpImageUris;
    NFTLuckyDip public s_luckyDip;

    function setUp() external {
        DeployNFTLuckyDip deployer = new DeployNFTLuckyDip();
        s_luckyDip = deployer.runMocked(msg.sender);
        vm.deal(user1, STARTING_BALANCE);
        vm.deal(user2, STARTING_BALANCE);
    }

    /**
     * MODIFIERS
     */
    modifier bidIsOpen() {
        vm.prank(msg.sender);
        s_luckyDip.openBid(0);
        assertEq(s_luckyDip.isLuckyDipPublished(0), true);
        _;
    }

    modifier oneBidWasMade() {
        vm.prank(msg.sender);
        s_luckyDip.openBid(0);
        assertEq(s_luckyDip.isLuckyDipPublished(0), true);
        vm.startPrank(user1);
        s_luckyDip.bidForLuckyDip{value: s_luckyDip.getNextBiddingPriceInWei(0)}(0);
        vm.stopPrank();
        assertEq(s_luckyDip.getBestBidder(0), user1);
        _;
    }

    /**
     * UNIT TESTS
     */
    function testLuckyDipAddingWorks() public view {
        assertEq(s_luckyDip.getLuckyDipNFTLength(0), DEFAULT_MOCK_IMAGE_URI_LENGTH);
        assertEq(s_luckyDip.isLuckyDipPublished(0), false);
        assertEq(s_luckyDip.getNbOfLuckyDips(), DEFAULT_MOCK_NB_OF_LUCKY_DIPS);
        assertEq(s_luckyDip.getLuckyDipDescription(0), DEFAULT_MOCK_DESCRIPTION);
        assertEq(s_luckyDip.getStartingBid(0), DEFAULT_MOCK_STARTINGBID);
        assertEq(s_luckyDip.getNextBiddingPriceInWei(0), (DEFAULT_MOCK_STARTINGBID + (0 * DEFAULT_MOCK_BIDSTEP)));
        // TODO encoding of svg seems to behave differently on each machine (base64 -i <path-to-svg-file>)
        //assertEq(luckyDip.getLuckyDipNFT(0, 0), MOCK_LUCKY_DIP_IMAGE_URI1);
    }

    function testMemberCantAddLuckyDip() public {
        s_tmpImageUris = new string[](0);
        s_tmpImageUris.push("fake uri which will fail");
        s_tmpImageUris.push("fake uri which will fail2");
        vm.prank(user1);
        vm.expectRevert();
        s_luckyDip.addLuckyDip("fake description", "fake symbol", "fake _name", 10000000000, 1000000000, s_tmpImageUris);
    }

    function testOwnerCanAddLuckyDip() public {
        s_tmpImageUris = new string[](0);
        s_tmpImageUris.push(ADDITIONNAL_MOCK_IMAGE_URI1);
        vm.prank(msg.sender);
        s_luckyDip.addLuckyDip(
            ADDITIONNAL_MOCK_DESCRIPTION,
            ADDITIONNAL_MOCK_SYMBOL,
            ADDITIONNAL_MOCK_NAME,
            ADDITIONNAL_MOCK_STARTINGBID,
            ADDITIONNAL_MOCK_BIDSTEP,
            s_tmpImageUris
        );
        assertEq(s_luckyDip.getNbOfLuckyDips(), ADDITIONNAL_MOCK_NB_OF_LUCKY_DIPS);
        assertEq(s_luckyDip.getLuckyDipNFTLength(1), ADDITIONNAL_MOCK_IMAGE_URI_LENGTH);
        assertEq(s_luckyDip.getLuckyDipDescription(1), ADDITIONNAL_MOCK_DESCRIPTION);
        assertEq(s_luckyDip.getStartingBid(1), ADDITIONNAL_MOCK_STARTINGBID);
        assertEq(s_luckyDip.getNextBiddingPriceInWei(1), ADDITIONNAL_MOCK_STARTINGBID);
        assertEq(s_luckyDip.isLuckyDipPublished(1), false);
    }

    function testOwnerCanOpenBid() public {
        assertEq(s_luckyDip.isLuckyDipPublished(0), false);
        vm.prank(msg.sender);
        s_luckyDip.openBid(0);
        assertEq(s_luckyDip.isLuckyDipPublished(0), true);
    }

    function testUserCantOpenBid() public {
        assertEq(s_luckyDip.isLuckyDipPublished(0), false);
        vm.prank(user1);
        vm.expectRevert(NFTLuckyDip.NFTLuckyDip__OwnerOnly.selector);
        s_luckyDip.openBid(0);
    }

    function testCantBidOnClosedBid() public {
        vm.startPrank(user1);
        // isolating this variable is mandatory because: https://ethereum.stackexchange.com/questions/158768/vm-expectrevert-is-not-working-as-expected-in-foundry
        uint256 sendValue = s_luckyDip.getNextBiddingPriceInWei(0);
        vm.expectRevert(abi.encodeWithSelector(NFTLuckyDip.NFTLuckyDip__BidNotOpenYet.selector, 0));
        s_luckyDip.bidForLuckyDip{value: sendValue}(0);
        vm.stopPrank();
    }

    function testCanBidWithvalidAmount() public bidIsOpen {
        vm.startPrank(user1);
        uint256 sendValue = s_luckyDip.getNextBiddingPriceInWei(0);
        s_luckyDip.bidForLuckyDip{value: sendValue}(0);
        vm.stopPrank();
        assertEq(s_luckyDip.getNextBiddingPriceInWei(0), (DEFAULT_MOCK_STARTINGBID + (1 * DEFAULT_MOCK_BIDSTEP)));
        assertEq(s_luckyDip.getBestBidder(0), user1);
        // TODO contract balance = sent value during bidding process
        // user1 balance = 10000 - value
        assertEq(address(user1).balance, STARTING_BALANCE - sendValue);
        assertEq(address(s_luckyDip).balance, sendValue);
    }

    function testCantBidWithInvalidAmount() public bidIsOpen {
        vm.startPrank(user1);
        uint256 wrongValue = s_luckyDip.getNextBiddingPriceInWei(0) + 1;
        vm.expectRevert(
            abi.encodeWithSelector(NFTLuckyDip.NFTLuckyDip__InvalidBiddingAmount.selector, user1, wrongValue)
        );
        s_luckyDip.bidForLuckyDip{value: wrongValue}(0);
        vm.stopPrank();
    }

    function testCantBidTwoTimesInARow() public bidIsOpen {
        vm.startPrank(user1);
        uint256 initialBiddingPrice = s_luckyDip.getNextBiddingPriceInWei(0);
        s_luckyDip.bidForLuckyDip{value: initialBiddingPrice}(0);
        assertEq(s_luckyDip.getBestBidder(0), user1);
        uint256 currentBuiddingPrice = s_luckyDip.getNextBiddingPriceInWei(0);
        assertNotEq(currentBuiddingPrice, initialBiddingPrice);
        vm.expectRevert(abi.encodeWithSelector(NFTLuckyDip.NFTLuckyDip__CantBidWhenAlreadyBestBidder.selector, 0));
        s_luckyDip.bidForLuckyDip{value: currentBuiddingPrice}(0);
        vm.stopPrank();
    }

    function testPreviousBidderGetHisMoneyBack() public oneBidWasMade {
        vm.startPrank(user2);
        uint256 sendValue = s_luckyDip.getNextBiddingPriceInWei(0);
        s_luckyDip.bidForLuckyDip{value: sendValue}(0);
        vm.stopPrank();
        assertEq(address(user1).balance, STARTING_BALANCE);
        assertEq(address(user2).balance, STARTING_BALANCE - sendValue);
        assertEq(address(s_luckyDip).balance, sendValue);
    }
    // todo : cant bid because of NFTLuckyDip__BidAlreadyAchieved

    // todo: cant end bid because no one ever participated

    // ending bid doesnt work if not one ever bid

    // after bid ending new owner of Booster contract is best bidder + and has correct nb of nft.

    // cant end bidding if contract funds not enpought
}
