// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/DrawContext.sol";
import "../Kohi/Graphics2D.sol";
import "../Kohi/RandomV1.sol";

import "./StarLight.sol";

library CityLightsStarLight {

    

    function renderStars(Graphics2D memory g, DrawContext memory f, VertexData[][] memory stars) external pure returns (uint8[] memory) {
        f.color = 4294967295;
        for (uint8 i = 0; i < stars.length; i++) {
            Graphics2DMethods.render(g, f, stars[i], true);
        }
        return g.buffer;
    }
}