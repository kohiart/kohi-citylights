// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../lib/ShapeLib.sol";
import "../RenderPanelSign.sol";
import "../GradientParams.sol";
import "../CityPanel.sol";

import "./CityLightsGradientFactory.sol";

library CityLightsPanelSignFactory {
    function create(
        GradientParams calldata g,
        CityPanel[] calldata cityPanels
    ) external pure returns (RenderPanelSign[][] memory signGroups) {
        signGroups = new RenderPanelSign[][](cityPanels.length);
        for (uint256 i; i < signGroups.length; i++) {
            signGroups[i] = new RenderPanelSign[](cityPanels[i].signs.length);
            for (uint256 j; j < signGroups[i].length; j++) {
                uint32 color;

                // create gradient
                (signGroups[i][j].gradients, color) = createPanelSignGradient(
                    g,
                    cityPanels[i].signs[j]
                );

                // create outline
                (
                    signGroups[i][j].outline,
                    signGroups[i][j].outlineColor
                ) = createPanelSign(g, cityPanels[i].signs[j], color);
            }
        }
    }

    function createPanelSign(
        GradientParams memory g,
        PanelSign memory panelSign,
        uint32 color
    ) private pure returns (VertexData[] memory, uint32) {
        int64 margin = 2147483648; /* 0.5 */
        int64 strokeWidth = Fix64.ONE;
        if (g.r == RenderMode.Light) {
            color = 4292993505; /* rgb(225, 225, 225) */
            strokeWidth = 2147483648 /* 0.5 */;
        }
        return
            ShapeLib.createRect(
                g,
                Fix64.add(panelSign.x * Fix64.ONE, margin),
                Fix64.add(
                    Fix64.add(
                        panelSign.y * Fix64.ONE,
                        int16(panelSign.h) * Fix64.ONE
                    ),
                    margin
                ),
                Fix64.sub(
                    Fix64.add(
                        panelSign.x * Fix64.ONE,
                        int16(panelSign.w) * Fix64.ONE
                    ),
                    margin
                ),
                Fix64.sub(panelSign.y * Fix64.ONE, margin),
                strokeWidth,
                color
            );
    }

    function createPanelSignGradient(
        GradientParams memory g,
        PanelSign memory panelSign
    ) private pure returns (RenderGradient[] memory, uint32 color) {
        return
            CityLightsGradientFactory.createPanelGradient(
                g.t,
                g.r,
                CityLightsGradientFactory.CreatePanelGradient(
                    panelSign.x * Fix64.ONE,
                    panelSign.y * Fix64.ONE,
                    int16(panelSign.w) * Fix64.ONE,
                    int16(panelSign.h) * Fix64.ONE,
                    panelSign.bgCol1,
                    panelSign.bgCol2,
                    g.h,
                    Vector2(0, 0),
                    Vector2(0, 0),
                    CustomPathMethods.create(2)
                )
            );
    }
}
