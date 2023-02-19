// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/DrawContext.sol";
import "../Kohi/Graphics2D.sol";
import "../Kohi/Matrix.sol";
import "../Kohi/CustomPath.sol";
import "../Kohi/Stroke.sol";

import "./factories/CityLightsGradientFactory.sol";
import "./lib/ShapeLib.sol";

import "./Errors.sol";
import "./GradientParams.sol";
import "./CityLightsPanels.sol";
import "./CityLightsGradient.sol";

import "./RenderPanels.sol";

library CityLightsPanel {

    function renderPanels(Graphics2D memory g, DrawContext memory f, RenderPanels calldata r) external pure returns(uint8[] memory) {
        renderPanels(g, f, r.shadow, r.shadowSigns, r.shadowSignText);
        renderPanels(g, f, r.city, r.citySigns, r.citySignText);
        return g.buffer;
    }

    function renderPanels(Graphics2D memory g, DrawContext memory f, RenderPanel[] calldata panels, RenderPanelSign[][] calldata signs, RenderPanelText[][] calldata text) private pure {
        for(uint i; i < panels.length; i++) {
            renderPanel(g, f, panels[i], signs[i], text[i]);
        }
    }

    function renderPanel(
        Graphics2D memory g,
        DrawContext memory f,
        RenderPanel calldata panel,
        RenderPanelSign[] calldata signs,
        RenderPanelText[] calldata text
    ) private pure {
        renderPanelGradient(g, f, panel);
        renderPanelSignGradients(g, f, signs);
        renderPanelText(g, f, text);        
        renderPanelSignOutlines(g, f, signs);
        renderPanelOutline(g, f, panel);
    }

    function renderPanelGradient(
        Graphics2D memory g,
        DrawContext memory f,
        RenderPanel calldata panel
    ) private pure {
        for (uint16 i; i < panel.gradients.length; i++) {
            f.color = panel.gradients[i].color;
            Graphics2DMethods.render(g, f, panel.gradients[i].vertices, true);
        }
    }

    function renderPanelOutline(
        Graphics2D memory g,
        DrawContext memory f,
        RenderPanel calldata panel
    ) private pure {
        f.color = panel.outlineColor;        
        Graphics2DMethods.render(g, f, panel.outline, true);
    }

    function renderPanelSignGradients(
        Graphics2D memory g,
        DrawContext memory f, 
        RenderPanelSign[] calldata panelSigns
    ) private pure {        
        for (uint16 i; i < panelSigns.length; i++) {            
            for (uint16 j = 0; j < panelSigns[i].gradients.length; j++) {
                f.color = panelSigns[i].gradients[j].color;
                Graphics2DMethods.render(g, f, panelSigns[i].gradients[j].vertices, true);
            }
        }
    }

    function renderPanelSignOutlines(
        Graphics2D memory g,
        DrawContext memory f,
        RenderPanelSign[] calldata panelSigns
    ) private pure {
        for (uint16 i; i < panelSigns.length; i++) {
            f.color = panelSigns[i].outlineColor;
            Graphics2DMethods.render(g, f, panelSigns[i].outline, true);
        }
    }

    function renderPanelText(
        Graphics2D memory g,
        DrawContext memory f,
        RenderPanelText[] calldata text
    ) private pure {
        for (uint32 i; i < text.length; i++) {                        
            RenderPanelText memory panelText = text[i];
            f.color = panelText.color;
            g.clippingData.clipPoly = panelText.clipPoly;
            uint32 vertexGroups = uint32(panelText.vertexGroups.length);                
            for (uint v; v < vertexGroups; v++) {                                
                Graphics2DMethods.render(g, f, panelText.vertexGroups[v], true);
            }
        }
        g.clippingData.clipPoly = new Vector2[](0);
    }
}
