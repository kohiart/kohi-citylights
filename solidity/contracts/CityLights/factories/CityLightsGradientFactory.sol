// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../../Kohi/CustomPath.sol";
import "../../Kohi/Matrix.sol";
import "../../Kohi/ColorMath.sol";
import "../../Kohi/Stroke.sol";

import "../RenderMode.sol";
import "../RenderGradient.sol";
import "../Errors.sol";

library CityLightsGradientFactory {
    function createBackgroundGradient(
        RenderMode mode,
        int64 x,
        int64 y,
        int64 w,
        int64 h,
        uint32 c1,
        uint32 c2
    ) external pure returns (RenderGradient[] memory gradients) {
        gradients = new RenderGradient[](5121);

        uint256 count;
        for (
            int64 i = y;
            i <= y + h;
            i += 1073741824 /* 0.25 */
        ) {
            int64 inter = Fix64.map(i, y, Fix64.add(y, h), 0, Fix64.ONE);
            uint32 color = ColorMath.lerp(c1, c2, inter);
            color = applyRenderMode(mode, color);

            CustomPath memory line = CustomPathMethods.create(2);
            CustomPathMethods.moveTo(line, x, Fix64.sub(h, i));
            CustomPathMethods.lineTo(line, Fix64.add(x, w), Fix64.sub(h, i));

            Stroke memory shape = StrokeMethods.create(
                CustomPathMethods.vertices(line),
                Fix64.ONE,
                200,
                200
            );
            gradients[count].vertices = StrokeMethods.vertices(shape);
            gradients[count].color = color;
            count++;
        }
    }

    struct CreatePanelGradient {
        int64 x;
        int64 y;
        int64 w;
        int64 h;
        uint32 c1;
        uint32 c2;
        int64 height;
        Vector2 v0;
        Vector2 v1;
        CustomPath line;
    }

    function createPanelGradient(
        Matrix memory m,
        RenderMode r,
        CreatePanelGradient memory f
    ) external pure returns (RenderGradient[] memory gradients, uint32 color) {
        uint256 count;
        for (
            int64 i = f.y;
            i <= f.y + f.h;
            i += 1073741824 /* 0.25 */
        ) {
            count++;
        }
        gradients = new RenderGradient[](count);
        count = 0;
        for (
            int64 i = f.y;
            i <= f.y + f.h;
            i += 1073741824 /* 0.25 */
        ) {
            int64 inter = Fix64.map(i, f.y, Fix64.add(f.y, f.h), 0, Fix64.ONE);
            color = ColorMath.lerp(f.c1, f.c2, inter);
            color = applyRenderMode(r, color);

            (f.v0.x, f.v0.y) = MatrixMethods.transform(m, f.x, i);
            (f.v1.x, f.v1.y) = MatrixMethods.transform(m, Fix64.add(f.x, f.w), i);
            f.v0.y = Fix64.sub(f.height, f.v0.y);
            f.v1.y = Fix64.sub(f.height, f.v1.y);

            f.line = CustomPathMethods.create(2);
            CustomPathMethods.moveTo(f.line, f.v0.x, f.v0.y);
            CustomPathMethods.lineTo(f.line, f.v1.x, f.v1.y);

            Stroke memory shape = StrokeMethods.create(
                CustomPathMethods.vertices(f.line),
                Fix64.ONE,
                200,
                200
            );
            gradients[count].vertices = StrokeMethods.vertices(shape);
            gradients[count].color = color;
            count++;
        }
    }

    function applyRenderMode(RenderMode renderMode, uint32 color)
        private
        pure
        returns (uint32)
    {
        if (renderMode == RenderMode.Dark) {
            return 4278190080;
        } else if (renderMode == RenderMode.City) {
            return color;
        } else if (renderMode == RenderMode.Light) {
            return 4294967295;
        }
        revert IndexOutOfRange();
    }
}