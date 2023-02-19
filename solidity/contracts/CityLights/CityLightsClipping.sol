// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/ClippingData.sol";

library CityLightsClipping {
    function getClippingPoly(RectangleInt memory box, Matrix memory transform, int64 h) external pure returns (Vector2[] memory clipPoly) {
        int64 left = box.left * Fix64.ONE;
        int64 right = box.right * Fix64.ONE;
        int64 bottom = box.bottom * Fix64.ONE;
        int64 top = box.top * Fix64.ONE;       

        Vector2 memory tl = MatrixMethods.transform(transform, Vector2(left, top));
        Vector2 memory tr = MatrixMethods.transform(transform, Vector2(right, top));
        Vector2 memory br = MatrixMethods.transform(transform, Vector2(right, bottom));
        Vector2 memory bl = MatrixMethods.transform(transform, Vector2(left, bottom));

        clipPoly = new Vector2[](4);
        clipPoly[0] = Vector2(tl.x, Fix64.sub(h, tl.y));
        clipPoly[1] = Vector2(tr.x, Fix64.sub(h, tr.y));
        clipPoly[2] = Vector2(br.x, Fix64.sub(h, br.y));
        clipPoly[3] = Vector2(bl.x, Fix64.sub(h, bl.y));

        return clipPoly;
    }
}