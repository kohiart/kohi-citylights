// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Parameters.sol";

interface ICityLightsParameters {

    function getParameters(uint tokenId, int32 seed) external view returns (Parameters memory parameters);
}