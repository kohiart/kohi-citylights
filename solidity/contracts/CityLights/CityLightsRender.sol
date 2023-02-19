// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import "./IRenderer.sol";
import "./IAttributes.sol";
import "./ICityLightsParameters.sol";
import "./Parameters.sol";
import "./Errors.sol";

import "../Kohi/Graphics2D.sol";
import "../Kohi/Fix64.sol";
import "../Kohi/Ellipse.sol";

import "./GradientParams.sol";

import "./factories/CityLightsPanelFactory.sol";
import "./factories/CityLightsPanelSignFactory.sol";
import "./factories/CityLightsStarLightFactory.sol";
import "./factories/CityLightsMoonFactory.sol";

import "./lib/TextLib.sol";

import "./CityLightsGradient.sol";
import "./CityLightsMoon.sol";
import "./CityLightsPanel.sol";
import "./CityLightsStarLight.sol";
import "./CityLightsClipping.sol";

import "./CityLightsFont.sol";
import "./RenderPanelText.sol";
import "./RenderPanels.sol";

contract CityLightsRender is Ownable {
    uint16 internal constant WIDTH = 1024;
    uint16 internal constant HEIGHT = 1280;

    CityLightsFont font;

    function setFont(address _address) external onlyOwner {
        font = CityLightsFont(_address);
    }

    function render(
        Parameters memory p
    ) external view returns (uint8[] memory) {
        Graphics2D memory g = Graphics2DMethods.create(WIDTH, HEIGHT);
        Graphics2DMethods.clear(g, 4278190080);

        GradientParams memory gradient = createGradientParams(p.renderMode);
        RenderPanelText[][] memory shadowSignText = createPanelText(p.shadowPanels, gradient);
        RenderPanelText[][] memory citySignText = createPanelText(p.cityPanels, gradient);

        RenderGradient[] memory gradients = CityLightsGradientFactory.createBackgroundGradient(p.renderMode, 0, 0, int32(g.width) * Fix64.ONE, int32(g.height) * Fix64.ONE, p.rootBG1, p.rootBG2);
        VertexData[][] memory stars = CityLightsStarLightFactory.create(p.starLight);
        RenderMoon[] memory moon = CityLightsMoonFactory.create(p.moon, HEIGHT);        
        (RenderPanel[] memory shadow, RenderPanel[] memory city) = CityLightsPanelFactory.create(gradient, p.shadowPanels, p.cityPanels);
        RenderPanelSign[][] memory shadowSigns = CityLightsPanelSignFactory.create(gradient, p.shadowPanels);
        RenderPanelSign[][] memory citySigns = CityLightsPanelSignFactory.create(gradient, p.cityPanels);

        DrawContext memory f;
        f.t = gradient.t;

        g.buffer = CityLightsGradient.renderGradient(g, f, gradients);
        g.buffer = CityLightsStarLight.renderStars(g, f, stars);
        g.buffer = CityLightsMoon.renderMoon(g, f, moon);

        RenderPanels memory r;
        r.shadow = shadow;
        r.shadowSigns = shadowSigns;
        r.shadowSignText = shadowSignText;
        r.city = city;
        r.citySigns = citySigns;
        r.citySignText = citySignText;

        return CityLightsPanel.renderPanels(g, f, r);
    }

    function createGradientParams(
        RenderMode r
    ) private pure returns (GradientParams memory gradient) {
        gradient.r = r;
        gradient.h = int16(HEIGHT) * Fix64.ONE;
        gradient.t = MatrixMethods.mul(
            MatrixMethods.newRotation(
                Fix64.div(Fix64.PI, 19327352832 /* 4.5 */)
            ),
            MatrixMethods.newTranslation(
                Fix64.div(int16(WIDTH) * Fix64.ONE, Fix64.TWO),
                0
            )
        );
    }

    function createPanelText(CityPanel[] memory panels, GradientParams memory gradient) private view returns (RenderPanelText[][] memory textGroups) {
        textGroups = new RenderPanelText[][](panels.length);
        for (uint256 i; i < panels.length; i++) {
            PanelSign[] memory signs = panels[i].signs;
            textGroups[i] = new RenderPanelText[](signs.length);
            for (uint256 j; j < signs.length; j++) {
                (textGroups[i][j]) = createPanelSignText(signs[j], gradient);
            }
        }
    }

    function createPanelSignText(PanelSign memory panelSign, GradientParams memory gradient) private view returns (RenderPanelText memory renderText) {
        int64 emSizeInPoints = Fix64.mul(
            int16(panelSign.txtHeight) * Fix64.ONE,
            3221225472 /* 0.75 */
        );
        int64 emSizeInPixels = Fix64.mul(
            Fix64.div(emSizeInPoints, 72 * Fix64.ONE /* POINTS_PER_INCH */),
            96 * Fix64.ONE /* PIXELS_PER_INCH */
        );
        int64 emScaling = Fix64.div(
            emSizeInPixels,
            1000 * Fix64.ONE /* UNITS_PER_EM */
        );

        renderText.color = panelSign.bgColText;        

        uint32[] memory codepoints = TextLib.getCodepoints(panelSign.word);
        GlyphInfo[] memory glyphs = new GlyphInfo[](codepoints.length);
        for (uint i; i < codepoints.length; i++) {
            uint32 codepoint = codepoints[i];
            GlyphInfo memory glyph = font.getGlyph(codepoint);
            glyphs[i] = glyph;
        }

        Vector2 memory origin = Vector2(
            Fix64.sub(
                Fix64.add(
                    panelSign.x * Fix64.ONE,
                    Fix64.div(int16(panelSign.w) * Fix64.ONE, Fix64.TWO)
                ),
                Fix64.div(getSizeX(glyphs, emScaling), Fix64.TWO)
            ),
            Fix64.add(
                Fix64.sub(
                    Fix64.add(
                        panelSign.y * Fix64.ONE,
                        int16(panelSign.h) * Fix64.ONE
                    ),
                    Fix64.div(int16(panelSign.h) * Fix64.ONE, Fix64.TWO)
                ),
                Fix64.div(int16(panelSign.txtHeight) * Fix64.ONE, Fix64.TWO)
            )
        );

        renderText.vertexGroups = vertices(glyphs, origin, gradient, emScaling);

        renderText.clipPoly = CityLightsClipping.getClippingPoly(RectangleInt(
            panelSign.x,
            panelSign.y,
            panelSign.x + int16(panelSign.w),
            panelSign.y + int16(panelSign.h)
        ), gradient.t, gradient.h);
    }

    struct CreateVertices {
        uint32 vertexCount;
        Vector2 currentOffset;
        Matrix transform;
        VertexData[] transformed;
    }

    function vertices(
        GlyphInfo[] memory glyphs,
        Vector2 memory origin,
        GradientParams memory gradient,
        int64 emScaling        
    ) private pure returns (VertexData[][] memory vertexGroups) {
        CreateVertices memory f;
        f.transform = MatrixMethods.mul(
            MatrixMethods.newIdentity(),
            MatrixMethods.newScale(emScaling)
        );

        vertexGroups = new VertexData[][](uint32(glyphs.length));

        for (uint32 i; i < vertexGroups.length; i++) {
            GlyphInfo memory glyph = glyphs[i];
            if (glyph.vertexCount == 0) {
                continue;
            }

            uint32 vertexCount = uint32(glyph.vertexCount);
            VertexData[] memory vertexGroup = new VertexData[](vertexCount);
            f.transformed = new VertexData[](vertexCount);

            // first transform (scale)
            ApplyTransform.applyTransform(
                glyph.vertices,
                f.transform,
                f.transformed
            );

            f.vertexCount = 0;
            for (uint32 j; j < vertexCount; j++) {

                if (f.transformed[j].command == Command.Stop) {
                    continue;
                }

                if (f.transformed[j].command == Command.EndPoly) {                                    
                    vertexGroup[f.vertexCount++] = VertexData(
                        f.transformed[j].command, Vector2(0, 0)
                    );
                    continue;
                }

                Vector2 memory position;

                // flip y axis
                position.x =  f.transformed[j].position.x;
                position.y = -f.transformed[j].position.y;

                // add current offset
                position.x += f.currentOffset.x;
                position.y += f.currentOffset.y;

                // add origin
                position.x += origin.x;
                position.y += origin.y;

                vertexGroup[f.vertexCount++] = VertexData(
                    f.transformed[j].command,
                    position
                );
            }

            f.currentOffset.x = Fix64.add(
                f.currentOffset.x,
                Fix64.mul(glyph.horizontalAdvanceX * Fix64.ONE, emScaling)
            );

            // second transform (rotate, y-shift)      
            f.transformed = new VertexData[](vertexCount);
            ApplyTransform.applyTransform(vertexGroup, gradient.t, f.transformed, gradient.h); 
            vertexGroups[i] = f.transformed;
        }
    }

    function getSizeX(
        GlyphInfo[] memory glyphs,
        int64 emScaling
    ) private pure returns (int64 x) {
        int64 currentLineX;
        for (uint i; i < glyphs.length; i++) {
            int32 horizontalAdvanceX = glyphs[i].horizontalAdvanceX;
            currentLineX = Fix64.add(
                currentLineX,
                Fix64.mul(horizontalAdvanceX * Fix64.ONE, emScaling)
            );
            if (currentLineX > x) {
                x = currentLineX;
            }
        }
    }
}
