// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./ICityLightsParameters.sol";
import "../Kohi/RandomV1.sol";

import "./Element.sol";
import "./Language.sol";
import "./English.sol";
import "./Japanese.sol";
import "./RenderMode.sol";
import "./Parameters.sol";

import "./factories/CityLightsMoonFactory.sol";
import "./factories/CityLightsStarLightFactory.sol";

import "./CityLightsPalette.sol";
import "./CityLightsMoon.sol";
import "./CityLightsPanels.sol";

contract CityLightsParameters is ICityLightsParameters {
    int32 internal constant MAX_COLOR_COUNT = 256;

    function getParameters(uint256, int32 seed)
        external
        pure
        override
        returns (Parameters memory cityLights)
    {
        uint16 width = 1024;
        uint16 height = 1280;

        RandomV1.PRNG memory prng = RandomV1.buildSeedTable(seed);

        cityLights.element = Element(uint32(RandomV1.next(prng, 7)));
        cityLights.language = Language(uint32(RandomV1.next(prng, 0, 2)));
        cityLights.renderMode = RenderMode(uint32(RandomV1.next(prng, 0, 2)));

        if (RandomV1.next(prng, 0, 30) == 7) {
            cityLights.renderMode = RenderMode.Light;
        }

        uint32[256] memory palette;
        (palette, cityLights.additionalElements, prng) = CityLightsPalette
            .getPalette(prng, cityLights.element);

        (cityLights.starLight, prng) = CityLightsStarLightFactory.init(
            prng,
            width,
            height
        );
        (cityLights.moon, prng) = CityLightsMoonFactory.init(
            prng,
            width,
            height,
            palette
        );

        string[] memory words = cityLights.language == Language.Jp
            ? Japanese.getWordList(cityLights.element)
            : English.getWordList(cityLights.element);

        uint8[10] memory sizes;
        for (uint8 i = 0; i < 10; i++) {
            if (i % 4 == 0) sizes[i] = uint8(int8(RandomV1.next(prng, 35, 75)));
            else if (i % 9 == 0)
                sizes[i] = uint8(int8(RandomV1.next(prng, 75, 150)));
            else sizes[i] = uint8(int8(RandomV1.next(prng, 5, 35)));
        }

        (cityLights.shadowPanels, prng) = CityLightsPanels.initShadowPanels(
            prng,
            CityLightsPanels.InitPanels(
                width,
                height,
                sizes,
                CityLightsPalette.getShadowPalette(),
                words
            )
        );

        (cityLights.cityPanels, prng) = CityLightsPanels.initCityPanels(
            prng,
            CityLightsPanels.InitPanels(width, height, sizes, palette, words)
        );

        cityLights.rootBG1 = palette[
            uint32(RandomV1.next(prng, MAX_COLOR_COUNT))
        ];
        cityLights.rootBG2 = 0xFF121212;

        cityLights.prng = prng;
    }
}
