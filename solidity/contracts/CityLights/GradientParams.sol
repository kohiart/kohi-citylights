// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./RenderMode.sol";
import "../Kohi/Matrix.sol";

struct GradientParams {
    RenderMode r;    
    Matrix t;
    int64 h;
}