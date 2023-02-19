// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

struct PanelSign {
    int32 x;
    int32 y;
    uint16 w;
    uint16 h;
    string word;
    uint32 bgCol1;
    uint32 bgCol2;
    uint32 bgColText;
    uint16 txtHeight;
}
