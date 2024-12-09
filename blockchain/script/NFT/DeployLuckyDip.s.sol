// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {NFTLuckyDip} from "../../src/NFT/NFTLuckyDip.sol";
import {LuckyDip} from "../../src/NFT/structs/LuckyDip.sol";
import {ConvertSvg} from "./ConvertSvg.sol";

/**
 * @title
 * @author ybim
 * @notice WARNING, json files contain the luckydips to the future bids. For any customization of these data, please stricty respect
 * the alphabetical order of the keys inside the json since it's a particularity of vm.parsejson()
 * https://book.getfoundry.sh/cheatcodes/parse-json
 */
contract DeployNFTLuckyDip is Script {
    using ConvertSvg for string;
    
    struct LuckyDipJson {
        uint256 bidStep;
        string description;
        string name;
        string[] nftCollection;
        uint256 startingBid;
        string symbol;
    }
    /*** CONST*/
    string constant SVG_FOLDER_PATH = "./feed/img/";
    /*** STATES*/
    NFTLuckyDip luckyDip;
    string[] s_tmpImageUris;
    /*** JSON FEED PATH*/
    string[] luckyDipsFeed =
        ["./feed/lucky-dip1.json", "./feed/lucky-dip2.json", "./feed/lucky-dip3.json", "./feed/lucky-dip4.json"];
    string[] mockedLuckyDipsFeed = ["./feed/mocked-luckydip1.json"];

    /*** ERROR*/
    error NftCollectionEmpty();

    function run() external returns (NFTLuckyDip) {
        deploy();
        populateLuckyDips();
        return luckyDip;
    }

    /*** CALLED BY TEST Contract to deploy and feed contract with mocked data*/
    function runMocked(address caller) external returns (NFTLuckyDip) {
        deploy();
        populateWithMockedLuckyDips(caller);
        return luckyDip;
    }

    function deploy() internal {
        vm.startBroadcast();
        luckyDip = new NFTLuckyDip();
        vm.stopBroadcast();
    }

    function populateLuckyDips() public {
        populateFromJson(msg.sender, luckyDipsFeed);
    }

    function populateWithMockedLuckyDips(address caller) public {
        populateFromJson(caller, mockedLuckyDipsFeed);
    }

    function populateFromJson(address caller, string[] memory feeds) internal {
        for (uint256 i = 0; i < feeds.length; i++) {
            string memory json = vm.readFile(feeds[i]);
            bytes memory data = vm.parseJson(json);
            LuckyDipJson memory luckyDipToAdd = abi.decode(data, (LuckyDipJson));
            if (luckyDipToAdd.nftCollection.length == 0) {
                revert NftCollectionEmpty();
            }
            s_tmpImageUris = new string[](0);
            for (uint256 j = 0; j < luckyDipToAdd.nftCollection.length; j++) {
                // set encoded svg and store temporaly
                s_tmpImageUris.push(
                    ConvertSvg.svgToImageURI(
                        vm.readFile(string(abi.encodePacked(SVG_FOLDER_PATH, luckyDipToAdd.nftCollection[j])))
                    )
                );
            }
            vm.prank(caller);
            luckyDip.addLuckyDip(
                luckyDipToAdd.description,
                luckyDipToAdd.symbol,
                luckyDipToAdd.name,
                luckyDipToAdd.startingBid,
                luckyDipToAdd.bidStep,
                s_tmpImageUris
            );
        }
    }
}
