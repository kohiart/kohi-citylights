// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./PanelSign.sol";

struct CityPanel {
    int32 x;
    int32 y;
    uint16 w;
    uint16 h;
    uint32 bgCol1;
    uint32 bgCol2;    
    PanelSign[] signs;
}