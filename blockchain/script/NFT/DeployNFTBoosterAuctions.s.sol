// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {NFTBoosterAuctions} from "../../src/NFT/NFTBoosterAuctions.sol";
import {Auction} from "../../src/NFT/structs/Auction.sol";
import {ConvertSvg} from "./ConvertSvg.sol";

/**
 * @title
 * @author ybim
 * @notice WARNING, json files contain the Auctions to the future bids. For any customization of these data, please stricty respect
 * the alphabetical order of the keys inside the json since it's a particularity of vm.parsejson()
 * https://book.getfoundry.sh/cheatcodes/parse-json
 */
contract DeployNFTBoosterAuctions is Script {
    using ConvertSvg for string;

    struct AuctionJson {
        uint256 bidDuration;
        uint256 bidStep;
        string description;
        string name;
        string[] nftCollection;
        uint256 startingBid;
        string symbol;
    }

    string constant SVG_FOLDER_PATH = "./feed/img/";
    NFTBoosterAuctions s_nftBoosterAuctions;
    string[] s_tmpImageUris;

    /*//////////////////////////////////////////////////////////////
                            JSON FEED
    //////////////////////////////////////////////////////////////*/
    string[] auctionsFeed =
        ["./feed/lucky-dip1.json", "./feed/lucky-dip2.json", "./feed/lucky-dip3.json", "./feed/lucky-dip4.json"];
    string[] mockedAuctionsFeed = ["./feed/mocked-luckydip1.json"];

    error NftCollectionEmpty();

    function run() external returns (NFTBoosterAuctions) {
        deploy();
        populateAuctions();
        return s_nftBoosterAuctions;
    }

    /*//////////////////////////////////////////////////////////////
     CALLED BY TEST Contract to deploy and feed contract with mocked data
    //////////////////////////////////////////////////////////////*/
    function runMocked(address caller) external returns (NFTBoosterAuctions) {
        deploy();
        populateWithMockedAuctions(caller);
        return s_nftBoosterAuctions;
    }

    function deploy() internal {
        vm.startBroadcast();
        s_nftBoosterAuctions = new NFTBoosterAuctions();
        vm.stopBroadcast();
    }

    function populateAuctions() internal {
        populateFromJson(msg.sender, auctionsFeed);
    }

    function populateWithMockedAuctions(address caller) internal {
        populateFromJson(caller, mockedAuctionsFeed);
    }

    function populateFromJson(address caller, string[] memory feeds) internal {
        for (uint256 i = 0; i < feeds.length; i++) {
            string memory json = vm.readFile(feeds[i]);
            bytes memory data = vm.parseJson(json);
            AuctionJson memory auctionToAdd = abi.decode(data, (AuctionJson));
            if (auctionToAdd.nftCollection.length == 0) {
                revert NftCollectionEmpty();
            }
            s_tmpImageUris = new string[](0);
            for (uint256 j = 0; j < auctionToAdd.nftCollection.length; j++) {
                // set encoded svg and store temporaly
                s_tmpImageUris.push(
                    ConvertSvg.svgToImageURI(
                        vm.readFile(string(abi.encodePacked(SVG_FOLDER_PATH, auctionToAdd.nftCollection[j])))
                    )
                );
            }

            vm.prank(caller);
            s_nftBoosterAuctions.addAuction(
                auctionToAdd.description,
                auctionToAdd.symbol,
                auctionToAdd.name,
                auctionToAdd.startingBid,
                auctionToAdd.bidStep,
                auctionToAdd.bidDuration,
                s_tmpImageUris
            );
        }
    }
}
