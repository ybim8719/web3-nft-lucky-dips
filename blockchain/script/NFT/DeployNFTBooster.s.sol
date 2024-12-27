// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {NFTBooster} from "../../src/NFT/NFTBooster.sol";
// import {Auction} from "../../src/NFT/structs/Auction.sol";
import {ConvertSvg} from "./ConvertSvg.sol";

/**
 * @title
 * @author ybim
 * @notice
 */
contract DeployNFTBooster is Script {
    using ConvertSvg for string;

    // struct AuctionJson {
    //     uint256 bidStep;
    //     string description;
    //     string name;
    //     string[] nftCollection;
    //     uint256 startingBid;
    //     string symbol;
    // }
    // /**
    //  * CONST
    //  */
    // string constant SVG_FOLDER_PATH = "./feed/img/";
    // /**
    //  * STATES
    //  */
    NFTBooster s_nftBooster;
    // string[] s_tmpImageUris;
    // /**
    //  * JSON FEED PATH
    //  */
    // string[] auctionsFeed =
    //     ["./feed/lucky-dip1.json", "./feed/lucky-dip2.json", "./feed/lucky-dip3.json", "./feed/lucky-dip4.json"];
    // string[] mockedAuctionsFeed = ["./feed/mocked-luckydip1.json"];

    /**
     * ERROR
     */
    error NftCollectionEmpty();

    function run() external returns (NFTBooster) {
        deploy();
        // populateAuctions();
        return s_nftBooster;
    }

    /**
     * CALLED BY TEST Contract to deploy and feed contract with mocked data
     */
    function runMocked(address caller) external returns (NFTBooster) {
        deploy();
        // populateWithMockedAuctions(caller);
        return s_nftBooster;
    }

    function deploy() internal {
        vm.startBroadcast();
        // s_nftBooster = new NFTBooster();
        vm.stopBroadcast();
    }

    // function populateAuctions() internal {
    //     populateFromJson(msg.sender, auctionsFeed);
    // }

    // function populateWithMockedAuctions(address caller) internal {
    //     populateFromJson(caller, mockedAuctionsFeed);
    // }
}
