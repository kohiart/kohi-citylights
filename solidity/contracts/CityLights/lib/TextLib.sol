// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "hardhat/console.sol";

contract TestableTextLib {
    function getCodepoints(
        string memory s
    ) external pure returns (uint32[] memory codepoints) {
        return TextLib.getCodepoints(s);
    }
}

library TextLib {
    /**
     * @notice Decodes a UTF-8 encoded string into an array of its corresponding Unicode code points.
     * @dev
     * - The first byte of each character determines the number of bytes in the character.
     * - For characters with 1 byte (0x00 - 0x7F), the code point is the same as the character itself.
     * - For characters with 2 bytes (0xC0 - 0xDF), the first 5 bits of the first byte and the entire second byte are used to encode the 10 bits of the Unicode code point.
     * - For characters with 3 bytes (0xE0 - 0xEF), the first 4 bits of the first byte, the next 6 bits of the first byte and the entire second byte, and the final 6 bits of the third byte are used to encode the Unicode code point.
     * - For characters with 4 bytes (0xF0 - 0xFF), the first 3 bits of the first byte, the next 6 bits of the second byte, the next 6 bits of the third byte, and the final 6 bits of the fourth byte are used to encode the Unicode code point.
     * @param s The UTF-8 encoded string to be decoded.
     * @return codepoints An array of the corresponding Unicode code points.
     */
    function getCodepoints(
        string memory s
    ) internal pure returns (uint32[] memory codepoints) {
        bytes memory buffer = bytes(s);
        uint32 length = uint32(buffer.length);

        uint32 count;
        for (uint32 i; i < length; i++) {
            uint8 b0 = uint8(buffer[i]);
            if (b0 <= 0x7F) {
                count++;
            } else if (b0 <= 0xDF) {
                ++i;
                count++;
            } else if (b0 <= 0xEF) {
                ++i;
                ++i;
                count++;
            } else {
                ++i;
                ++i;
                ++i;
                count++;
            }
        }

        uint32 codepoint;
        uint32 index;
        codepoints = new uint32[](count);
        for (uint32 i; i < length; i++) {
            uint8 b0 = uint8(buffer[i]);
            if (b0 <= 0x7F) {
                codepoint = uint32(b0);
            } else if (b0 <= 0xDF) {
                uint8 b1 = uint8(buffer[++i]);
                codepoint = ((uint32(b0 & 0x1F) << 6) | uint32(b1 & 0x3F));
            } else if (b0 <= 0xEF) {
                uint8 b1 = uint8(buffer[++i]);
                uint8 b2 = uint8(buffer[++i]);
                codepoint = ((uint32(b0 & 0x0F) << 12) |
                    (uint32(b1 & 0x3F) << 6) |
                    uint32(b2 & 0x3F));
            } else {
                uint8 b1 = uint8(buffer[++i]);
                uint8 b2 = uint8(buffer[++i]);
                uint8 b3 = uint8(buffer[++i]);
                codepoint = uint32(
                    (uint32(b0 & 0x07) << 18) |
                        uint32(uint8(b1 & 0x3F) << 12) |
                        uint32(uint8(b2 & 0x3F) << 6) |
                        uint32(uint8(b3 & 0x3F))
                );
            }
            codepoints[index++] = codepoint;
        }
    }
}
