// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/RandomV1.sol";
import "./Element.sol";
import "./Errors.sol";

import "./Earth.sol";
import "./Fire.sol";
import "./Hologram.sol";
import "./Metal.sol";
import "./Water.sol";
import "./Wind.sol";
import "./Wood.sol";

library CityLightsPalette {
    uint8 internal constant NUM_AUX_COLOURS = 64;    

    function getShadowPalette()
        external
        pure
        returns (uint32[256] memory colors)
    {
        colors[0] = 0x22000000;
        colors[1] = 0x11000000;
        colors[2] = 0xFF000000;
        colors[3] = 0x22000000;
        colors[4] = 0x11000000;
        colors[5] = 0xFF000000;
        colors[6] = 0x22000000;
        colors[7] = 0x11000000;
        colors[8] = 0xFF000000;
        colors[9] = 0x22000000;
        colors[10] = 0x11000000;
        colors[11] = 0xFF000000;
        colors[12] = 0x22000000;
        colors[13] = 0x11000000;
        colors[14] = 0xFF000000;
        colors[15] = 0x22000000;
        colors[16] = 0x11000000;
        colors[17] = 0xFF000000;
    }

    function getPalette(
        RandomV1.PRNG memory prng,
        Element element
    ) external pure returns (uint32[256] memory palette, Element[6] memory additionalElements, RandomV1.PRNG memory) {
        uint32[256][4] memory hatch;

        if (element == Element.Earth) {
            hatch[0] = Earth.getPalette(0);
            hatch[1] = Earth.getPalette(1);
            hatch[2] = Earth.getPalette(2);
            hatch[3] = Earth.getPalette(3);
        } else if (element == Element.Fire) {
            hatch[0] = Fire.getPalette(0);
            hatch[1] = Fire.getPalette(1);
            hatch[2] = Fire.getPalette(2);
            hatch[3] = Fire.getPalette(3);
        } else if (element == Element.Hologram) {
            hatch[0] = Hologram.getPalette(0);
            hatch[1] = Hologram.getPalette(1);
            hatch[2] = Hologram.getPalette(2);
            hatch[3] = Hologram.getPalette(3);
        } else if (element == Element.Metal) {
            hatch[0] = Metal.getPalette(0);
            hatch[1] = Metal.getPalette(1);
            hatch[2] = Metal.getPalette(2);
            hatch[3] = Metal.getPalette(3);
        } else if (element == Element.Water) {
            hatch[0] = Water.getPalette(0);
            hatch[1] = Water.getPalette(1);
            hatch[2] = Water.getPalette(2);
            hatch[3] = Water.getPalette(3);
        } else if (element == Element.Wind) {
            hatch[0] = Wind.getPalette(0);
            hatch[1] = Wind.getPalette(1);
            hatch[2] = Wind.getPalette(2);
            hatch[3] = Wind.getPalette(3);
        } else if (element == Element.Wood) {
            hatch[0] = Wood.getPalette(0);
            hatch[1] = Wood.getPalette(1);
            hatch[2] = Wood.getPalette(2);
            hatch[3] = Wood.getPalette(3);
        } else revert IndexOutOfRange();

        uint16[] memory counts = new uint16[](7);
        
        for (uint8 i = 0; i < 4; i++) {
            for (uint8 j = 0; j < NUM_AUX_COLOURS; j++) {
                Element randomElement = Element(
                    uint32(RandomV1.next(prng, 7))
                );

                uint8 bank = uint8(int8(RandomV1.next(prng, 0, 4)));
                uint8 index = uint8(int8(RandomV1.next(prng, 0, 255)));
                uint32 color;

                if (randomElement == Element.Earth) {
                    color = Earth.getPalette(bank)[index];
                    counts[2]++;
                } else if (randomElement == Element.Fire) {
                    color = Fire.getPalette(bank)[index];
                    counts[0]++;
                } else if (randomElement == Element.Hologram) {
                    color = Hologram.getPalette(bank)[index];
                    counts[6]++;
                } else if (randomElement == Element.Metal) {
                    color = Metal.getPalette(bank)[index];
                    counts[5]++;
                } else if (randomElement == Element.Water) {
                    color = Water.getPalette(bank)[index];
                    counts[1]++;
                } else if (randomElement == Element.Wind) {
                    color = Wind.getPalette(bank)[index];
                    counts[3]++;
                } else if (randomElement == Element.Wood) {
                    color = Wood.getPalette(bank)[index];
                    counts[4]++;
                } else revert IndexOutOfRange();

                hatch[i][index] = color;
            }
        }

        for(uint8 i = 0; i < 6; i++) {
            additionalElements[i] = getNextElement(counts);
        }       

        palette = hatch[uint32(RandomV1.next(prng, 4))];
        return (palette, additionalElements, prng);
    }

    function getNextElement(uint16[] memory counts) private pure returns(Element){
        uint value; 
        uint index;
        uint16 i;
        for(i = 0; i < counts.length; i++) {
            if(counts[i] > value) {
                value = counts[i];                
                index = i;
            } 
        }
        counts[index] = 0;
        return Element(index);
    }
}