// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/Graphics2D.sol";
import "./RenderMoon.sol";

library CityLightsMoon {
    

    function renderMoon(
        Graphics2D memory g,
        DrawContext memory f,
        RenderMoon[] memory moons
    ) external pure returns (uint8[] memory) {
        for (uint8 i = 0; i < moons.length; i++) {
            f.color = moons[i].color;
            Graphics2DMethods.render(g, f, moons[i].vertices, true);
        }
        return g.buffer;
    }
}
