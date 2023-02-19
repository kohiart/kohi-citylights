// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../../Kohi/VertexData.sol";
import "../../Kohi/CustomPath.sol";
import "../../Kohi/Stroke.sol";

import "../GradientParams.sol";

library ShapeLib {
    function createRect(
        GradientParams memory g,
        int64 boxLeft,
        int64 boxBottom,
        int64 boxRight,
        int64 boxTop,
        int64 strokeWidth,
        uint32 color
    ) internal pure returns (VertexData[] memory, uint32) {
        Vector2 memory v0 = Vector2(boxLeft, boxTop);
        Vector2 memory v1 = Vector2(boxRight, boxTop);
        Vector2 memory v2 = Vector2(boxRight, boxBottom);
        Vector2 memory v3 = Vector2(boxLeft, boxBottom);

        (v0.x, v0.y) = MatrixMethods.transform(g.t, v0.x, v0.y);
        (v1.x, v1.y) = MatrixMethods.transform(g.t, v1.x, v1.y);
        (v2.x, v2.y) = MatrixMethods.transform(g.t, v2.x, v2.y);
        (v3.x, v3.y) = MatrixMethods.transform(g.t, v3.x, v3.y);

        v0.y = Fix64.sub(g.h, v0.y);
        v1.y = Fix64.sub(g.h, v1.y);
        v2.y = Fix64.sub(g.h, v2.y);
        v3.y = Fix64.sub(g.h, v3.y);

        CustomPath memory line = CustomPathMethods.create(12);
        CustomPathMethods.moveTo(line, v0.x, v0.y);
        CustomPathMethods.lineTo(line, v1.x, v1.y);
        CustomPathMethods.lineTo(line, v2.x, v2.y);
        CustomPathMethods.lineTo(line, v3.x, v3.y);
        CustomPathMethods.lineTo(line, v0.x, v0.y);

        Stroke memory outline = StrokeMethods.create(
            CustomPathMethods.vertices(line),
            strokeWidth,
            200,
            200
        );

        return (StrokeMethods.vertices(outline), color);
    }
}
