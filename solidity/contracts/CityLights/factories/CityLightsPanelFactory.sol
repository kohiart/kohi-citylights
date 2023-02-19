// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../../Kohi/DrawContext.sol";
import "../../Kohi/Graphics2D.sol";
import "../../Kohi/Matrix.sol";
import "../../Kohi/CustomPath.sol";
import "../../Kohi/Stroke.sol";

import "../Errors.sol";
import "../GradientParams.sol";
import "../CityLightsPanels.sol";
import "../CityLightsGradient.sol";
import "../RenderPanel.sol";

import "./CityLightsGradientFactory.sol";
import "../lib/ShapeLib.sol";

library CityLightsPanelFactory {
    function create(
        GradientParams calldata g,
        CityPanel[] calldata shadowPanels,
        CityPanel[] calldata cityPanels
    )
        external
        pure
        returns (RenderPanel[] memory shadow, RenderPanel[] memory city)
    {
        shadow = createPanels(g, shadowPanels);
        city = createPanels(g, cityPanels);
    }

    function createPanels(
        GradientParams calldata g,
        CityPanel[] calldata cityPanels
    ) private pure returns (RenderPanel[] memory panels) {
        panels = new RenderPanel[](cityPanels.length);
        for (uint256 i = 0; i < cityPanels.length; i++) {
            CityPanel memory cityPanel = cityPanels[i];
            (panels[i].gradients, ) = CityLightsGradientFactory.createPanelGradient(
                g.t,
                g.r,
                CityLightsGradientFactory.CreatePanelGradient(
                    cityPanel.x * Fix64.ONE,
                    cityPanel.y * Fix64.ONE,
                    int16(cityPanel.w) * Fix64.ONE,
                    int16(cityPanel.h) * Fix64.ONE,
                    cityPanel.bgCol1,
                    cityPanel.bgCol2,
                    g.h,
                    Vector2(0, 0),
                    Vector2(0, 0),
                    CustomPathMethods.create(2)
                )
            );
            (panels[i].outline, panels[i].outlineColor) = createPanelOutline(g, cityPanel);
        }
    }

    function createPanelOutline(GradientParams memory g, CityPanel memory panel)
        private
        pure
        returns (VertexData[] memory, uint32)
    {
        uint32 color = applyRenderMode(g.r);
        
        int64 margin = 2147483648; /* 0.5 */
        int64 boxLeft = Fix64.add((panel.x - 1) * Fix64.ONE, margin);
        int64 boxBottom = Fix64.add(Fix64.add((panel.y - 1) * Fix64.ONE, (int16(panel.h) + 2) * Fix64.ONE), margin);
        int64 boxRight = Fix64.sub(Fix64.add((panel.x - 1) * Fix64.ONE, (int16(panel.w) + 2) * Fix64.ONE), margin);
        int64 boxTop = Fix64.sub((panel.y - 1) * Fix64.ONE, margin);

        return ShapeLib.createRect(g, boxLeft, boxBottom, boxRight, boxTop, 6442450944 /* 1.5 */, color);
    }

    function applyRenderMode(RenderMode renderMode)
        private
        pure
        returns (uint32)
    {
        if (renderMode == RenderMode.Dark) {
            return 4278190080; // black
        } else if (renderMode == RenderMode.City) {
            return 4278190080; // black
        } else if (renderMode == RenderMode.Light) {
            return 4294967295; // white
        }
        revert IndexOutOfRange();
    }
}