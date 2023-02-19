// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "../Kohi/VertexData.sol";

struct RenderMoon {
    VertexData[] vertices;
    uint32 color;
}