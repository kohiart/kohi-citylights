// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

/*
Font Attribution:
================

CityLightsFont uses glyphs from [Noto Sans JP](https://fonts.google.com/noto/specimen/Noto+Sans+JP/about), 
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)

CityLightsFont uses glyphs from [Nanum Gothing Coding](https://fonts.google.com/specimen/Nanum+Gothic+Coding/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)

CityLightsFont uses glyphs from [Sawarabi Gothic](https://fonts.google.com/specimen/Sawarabi+Gothic/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)
*/

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../Kohi/VertexData.sol";
import "./lib/SSTORE2.sol";
import "./lib/BufferUtils.sol";

struct GlyphInfo {
    int32 horizontalAdvanceX;
    VertexData[] vertices;
    uint32 vertexCount;
}

contract CityLightsFont is Ownable {
    mapping(uint32 => uint16) glyphLengths;
    mapping(uint32 => address) glyphData;    

    function setGlyph(uint32 codepoint, uint16 length, bytes memory data) external onlyOwner {
        glyphLengths[codepoint] = length;
        glyphData[codepoint] = SSTORE2.write(data);
    }

    function getGlyph(
        uint32 codepoint
    ) external view returns (GlyphInfo memory glyph) {
        uint16 length = glyphLengths[codepoint];
        if (length == 0) {
            return glyph;
        }
        bytes memory buffer = BufferUtils.decompress(
            glyphData[codepoint],
            length
        );

        uint position;
        (glyph.horizontalAdvanceX, position) = BufferUtils.readInt32(
            position,
            buffer
        );
        
        (glyph.vertexCount, position) = BufferUtils.readUInt32(
            position,
            buffer
        );
        glyph.vertices = new VertexData[](uint32(glyph.vertexCount));
        for (uint32 i; i < glyph.vertexCount; i++) {
            (glyph.vertices[i].position.x, position) = BufferUtils.readInt64(
                position,
                buffer
            );
            (glyph.vertices[i].position.y, position) = BufferUtils.readInt64(
                position,
                buffer
            );
            uint8 command;
            (command, position) = BufferUtils.readByte(position, buffer);
            glyph.vertices[i].command = Command(command);
        }
    }
}