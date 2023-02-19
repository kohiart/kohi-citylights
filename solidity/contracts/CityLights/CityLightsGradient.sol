// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./StarLight.sol";
import "./CityPanel.sol";
import "./RenderMode.sol";
import "./Errors.sol";

import "../Kohi/VertexData.sol";
import "../Kohi/ColorMath.sol";
import "../Kohi/CustomPath.sol";
import "../Kohi/Ellipse.sol";
import "../Kohi/Stroke.sol";

import "./RenderGradient.sol";

import "../Kohi/DrawContext.sol";
import "../Kohi/Graphics2D.sol";

library CityLightsGradient {
    function renderGradient(
        Graphics2D memory g,
        DrawContext memory f,
        RenderGradient[] memory gradients
    ) external pure returns (uint8[] memory) {
        for (uint16 i = 0; i < gradients.length; i++) {
            f.color = gradients[i].color;
            Graphics2DMethods.render(g, f, gradients[i].vertices, true);
        }
        return g.buffer;
    }
}
