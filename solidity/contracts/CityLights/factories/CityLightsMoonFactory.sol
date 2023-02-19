// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../../Kohi/Ellipse.sol";
import "../../Kohi/ColorMath.sol";
import "../../Kohi/RandomV1.sol";

import "../Errors.sol";
import "../Moon.sol";
import "../RenderMoon.sol";

library CityLightsMoonFactory {
    function init(
        RandomV1.PRNG memory prng,
        uint16 width,
        uint16 height,
        uint32[256] memory palette
    ) external pure returns (Moon memory moon, RandomV1.PRNG memory) {
        moon.mode = uint8(int8(RandomV1.next(prng, 0, 2)));
        moon.size = uint16(int16(RandomV1.next(prng, 100, 300)));
        moon.x = RandomV1.next(
            prng,
            int32(uint32(moon.size) / 2),
            int16(width) - int16(moon.size) / 2
        );

        int32 minY = int16(moon.size);
        int32 maxY = int16(height) / 4 - int16(moon.size) / 4;
        int32 minB = int32(Fix64.min(minY, maxY));
        int32 maxB = int32(Fix64.max(minY, maxY));
        moon.y = RandomV1.next(prng, minB, maxB);

        moon.color = palette[
            uint32(RandomV1.next(prng, int16(int256(palette.length))))
        ];

        return (moon, prng);
    }

    function create(Moon calldata moon, uint16 height)
        external
        pure
        returns (RenderMoon[] memory moons)
    {
        int64 mx = int32(moon.x) * Fix64.ONE;
        int64 my = (int16(height) - int32(moon.y)) * Fix64.ONE;
        int64 mr = Fix64.div(int16(moon.size) * Fix64.ONE, Fix64.TWO);

        if (moon.mode == 0) {
            moons = new RenderMoon[](1);            
            Ellipse memory shape = EllipseMethods.circle(mx, my, mr);
            moons[0].vertices = EllipseMethods.vertices(shape);
            moons[0].color = moon.color;
        } else if (moon.mode == 1) {
            uint32 moonGlow = ColorMath.toColor(uint8(25), uint8(moon.color >> 16), uint8(moon.color >> 8), uint8(moon.color >> 0));
            moons = new RenderMoon[](16);
            for(uint8 i = 0; i < 15; i++) {
                int32 bloom = (int8(i) * (int8(i) / 4));
                int32 r = int16(moon.size) + bloom;
                int64 hr = Fix64.div(r * Fix64.ONE, Fix64.TWO);
                Ellipse memory shape = EllipseMethods.circle(mx, my, hr);
                moons[i].vertices = EllipseMethods.vertices(shape);
                moons[i].color = moonGlow;
            }
            {
                Ellipse memory shape = EllipseMethods.circle(mx, my, mr);
                moons[15].vertices = EllipseMethods.vertices(shape);
                moons[15].color = moon.color;
            }            
        } else {
            revert IndexOutOfRange();
        }
    }
}