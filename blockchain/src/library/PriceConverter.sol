// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// Why is this a library and not abstract?
library PriceConverter {
    // We could make this public, but then we'd have to deploy it
    function getUsdFor1eth(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // Sepolia: xx USD for 1ETH (ETH/USD) Address https://docs.chain.link/data-feeds/price-feeds/addresses
        (, int256 answer,,,) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit () // since it's basically 8 decimals.
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 usdAmountToConvert, AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        uint256 usdFor1eth = getUsdFor1eth(priceFeed);
        // example :
        // usdAmount is 200 USD
        // rate is 1 ETH = 2000 USD => received 2000 x 1e8 (decimals) means 2000 x 1e8 for 1e8 ETH
        // result is 0.1ETH = 1e17 wei
        uint256 usdAmountInWei = (usdAmountToConvert * 1e18 * 1e8) / usdFor1eth;

        return usdAmountInWei;
    }
}
