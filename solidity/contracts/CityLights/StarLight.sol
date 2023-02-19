// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./Star.sol";

struct StarLight {
    uint8 starCount;
    Star[] stars;
}