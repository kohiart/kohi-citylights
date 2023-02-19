// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/VertexData.sol";
import "./CityPanel.sol";
import "./RenderMode.sol";

import "../Kohi/RandomV1.sol";

library CityLightsPanels {
    int8 internal constant MIN_PANEL_SIGNS = 5;
    int8 internal constant MAX_PANEL_SIGNS = 40;

    int8 internal constant MIN_SHADOW_PANELS = 10;
    int8 internal constant MAX_SHADOW_PANELS = 50;

    int8 internal constant MIN_CITY_PANELS = 30;
    int8 internal constant MAX_CITY_PANELS = 115;

    uint8 internal constant V_SPC = 3;
    uint8 internal constant PIVOT = 1;

    struct InitPanels {
        uint16 width;
        uint16 height;
        uint8[10] sizes;
        uint32[256] palette;
        string[] words;
    }

    function initShadowPanels(
        RandomV1.PRNG memory prng,
        InitPanels calldata f        
    ) external pure returns (CityPanel[] memory panels, RandomV1.PRNG memory) {
        uint8 panelCount = uint8(
            int8(RandomV1.next(prng, MIN_SHADOW_PANELS, MAX_SHADOW_PANELS))
        );

        panels = new CityPanel[](panelCount);

        for (uint8 i; i < panelCount; i++) {
            (panels[i], prng) = createPanel(
                prng,
                CreatePanel(
                    RandomV1.next(prng, 100, int16(f.width) - 100),
                    RandomV1.next(prng, 0, int16(f.height) / 2),
                    true,
                    f.sizes,
                    f.palette,
                    f.words
                )
            );
        }

        return (panels, prng);
    }

    function initCityPanels(
        RandomV1.PRNG memory prng,
        InitPanels calldata f        
    ) external pure returns (CityPanel[] memory panels, RandomV1.PRNG memory) {
        uint8 panelCount = uint8(
            int8(RandomV1.next(prng, MIN_CITY_PANELS, MAX_CITY_PANELS))
        );

        panels = new CityPanel[](panelCount);

        for (uint8 i = 0; i < panelCount; i++) {
            (panels[i], prng) = createPanel(
                prng,
                CreatePanel(
                    RandomV1.next(prng, 0, int16(f.width) / 2 + 100),
                    RandomV1.next(prng, 0, int16(f.height) - int16(f.height) / 3),
                    false,
                    f.sizes,
                    f.palette,
                    f.words
                )
            );
        }

        return (panels, prng);
    }

    struct CreatePanel {
        int32 x;
        int32 y;
        bool shadow;
        uint8[10] sizes;
        uint32[256] palette;
        string[] words;
    }

    function createPanel(RandomV1.PRNG memory prng, CreatePanel memory s)
        private
        pure
        returns (CityPanel memory panel, RandomV1.PRNG memory)
    {
        uint16 colors = s.shadow ? 18 : 256;

        panel.x = s.x;
        panel.y = s.y;
        panel.w = s.sizes[
            uint32(RandomV1.next(prng, int16(int256(s.sizes.length - 1))))
        ];
        panel.bgCol1 = s.palette[uint32(RandomV1.next(prng, int16(colors)))];
        panel.bgCol2 = s.palette[uint32(RandomV1.next(prng, int16(colors)))];

        uint8 signCount = uint8(
            int8(RandomV1.next(prng, MIN_PANEL_SIGNS, MAX_PANEL_SIGNS))
        );

        CreatePanelSign memory f;
        f.minSignHeight = 15;
        f.maxSignHeight = uint16(
            uint256(max(int16(f.minSignHeight), int16(panel.w)))
        );

        uint16 totalSignsHeight;
        panel.signs = new PanelSign[](signCount);
        for (uint8 i; i < signCount; i++) {
            f.shadow = s.shadow;
            f.i = i;
            f.panel = panel;
            f.previous = i > 0
                ? panel.signs[i - 1]
                : PanelSign(0, 0, 0, 0, "", 0, 0, 0, 0);
            f.palette = s.palette;
            f.words = s.words;

            (panel.signs[i], prng) = createPanelSign(prng, f);
            totalSignsHeight += panel.signs[i].h + V_SPC;
        }

        panel.h = totalSignsHeight + 1;

        return (panel, prng);
    }

    struct CreatePanelSign {
        bool shadow;
        uint8 i;
        CityPanel panel;
        PanelSign previous;
        uint32[256] palette;
        uint16 minSignHeight;
        uint16 maxSignHeight;
        string[] words;
    }

    function createPanelSign(
        RandomV1.PRNG memory prng,
        CreatePanelSign memory f
    ) private pure returns (PanelSign memory sign, RandomV1.PRNG memory) {
        uint16 colors = f.shadow ? 18 : 256;

        sign.word = f.words[
            uint32(RandomV1.next(prng, int8(int256(f.words.length))))
        ];

        if (f.i > 0) {
            int16 signH = int16(
                RandomV1.next(
                    prng,
                    int16(f.minSignHeight),
                    int16(f.maxSignHeight)
                )
            );
            sign.x = f.panel.x + int8(PIVOT);
            sign.y = f.previous.y + int16(f.previous.h) + int8(V_SPC);
            sign.w = f.panel.w - 2;
            sign.h = uint16(signH);
        } else {
            sign.x = f.panel.x + int8(PIVOT);
            sign.y = f.panel.y + int8(PIVOT);
            sign.w = f.panel.w - 2;
            sign.h = 10;
        }

        sign.txtHeight = uint16(
            int16(
                RandomV1.next(
                    prng,
                    int16(sign.w) - (int16(sign.w) / 4),
                    int16(sign.w) + 25
                )
            )
        );

        sign.bgCol1 = f.palette[uint32(RandomV1.next(prng, int16(colors)))];
        sign.bgCol2 = f.palette[uint32(RandomV1.next(prng, int16(colors)))];
        sign.bgColText = f.palette[uint32(RandomV1.next(prng, int16(colors)))];

        return (sign, prng);
    }

    function max(int256 a, int256 b) internal pure returns (int256) {
        return a >= b ? a : b;
    }
}
