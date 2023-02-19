// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./RenderGradient.sol";

struct RenderPanelSign {
    RenderGradient[] gradients;
    VertexData[] outline;
    uint32 outlineColor;
}