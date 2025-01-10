// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {NFTBoosterAuctions} from "../../src/NFT/NFTBoosterAuctions.sol";
import {Auction} from "../../src/NFT/structs/Auction.sol";
import {ConvertSvg} from "./library/ConvertSvg.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {AuctionJson} from "../../feed/struct/AuctionJson.sol";

/**
 * @notice This script is made to feed most recently deployed NFTBoosterAuctions contract with 4 boosters (also called lucky dips)
 * It has to be launched after the deployment of the original contract.
 */
contract AddAuctions is Script {
    using ConvertSvg for string;

    string constant SVG_FOLDER_PATH = "./feed/img/";

    string[] auctionsFeed = [
        "./feed/random-auction1.json",
        "./feed/random-auction2.json",
        "./feed/random-auction3.json",
        "./feed/random-auction4.json"
    ];
    string[] s_tmpImageUris;

    error NftCollectionEmpty();

    function feedFromJson(address contractToFeed, address caller) internal {
        NFTBoosterAuctions target = NFTBoosterAuctions(contractToFeed);
        for (uint256 i = 0; i < auctionsFeed.length; i++) {
            string memory json = vm.readFile(auctionsFeed[i]);
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
            vm.startBroadcast(caller);
            target.addAuction(
                auctionToAdd.description,
                auctionToAdd.symbol,
                auctionToAdd.name,
                auctionToAdd.startingBid,
                auctionToAdd.bidStep,
                auctionToAdd.bidDuration,
                s_tmpImageUris
            );
            vm.stopBroadcast();
        }
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("NFTBoosterAuctions", block.chainid);
        feedFromJson(mostRecentlyDeployed, msg.sender);
    }
}
