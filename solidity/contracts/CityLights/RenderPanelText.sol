// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/RectangleInt.sol";
import "../Kohi/VertexData.sol";

struct RenderPanelText {
    Vector2[] clipPoly;
    VertexData[][] vertexGroups;
    uint32 color;
}