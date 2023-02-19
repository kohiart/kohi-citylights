// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../../Kohi/Ellipse.sol";
import "../../Kohi/RandomV1.sol";
import "../../Kohi/VertexData.sol";

import "../StarLight.sol";

library CityLightsStarLightFactory {
    uint8 internal constant MAX_STARS = 50;

    function init(
        RandomV1.PRNG memory prng,
        uint16 width,
        uint16 height
    ) external pure returns (StarLight memory starlight, RandomV1.PRNG memory) {

        starlight.starCount = uint8(uint32(RandomV1.next(prng, 0, int8(MAX_STARS))));
        starlight.stars = new Star[](starlight.starCount);

        for (uint8 i = 0; i < starlight.starCount; i++) {
            int32 x = RandomV1.next(prng, 0, int16(width));
            int32 y = RandomV1.next(prng, 0, int16(height));
            int32 s = RandomV1.next(prng, 1, 3);
            starlight.stars[i] = Star(uint32(x), uint32(y), uint32(s));
        }

        return (starlight, prng);
    }
    
    function create(StarLight calldata starLight)
        external
        pure
        returns (VertexData[][] memory stars)
    {
        stars = new VertexData[][](starLight.starCount);

        for (uint8 i = 0; i < starLight.starCount; i++) {
            Star memory star = starLight.stars[i];            
            Ellipse memory shape = EllipseMethods.circle(
                int32(star.x) * Fix64.ONE, 
                int32(star.y) * Fix64.ONE, 
                Fix64.div(int32(star.s) * Fix64.ONE, Fix64.TWO)
            );            
            stars[i] = EllipseMethods.vertices(shape);
        }
    }
}