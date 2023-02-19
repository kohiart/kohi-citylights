// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./Element.sol";
import "./Language.sol";
import "./RenderMode.sol";
import "./StarLight.sol";
import "./Moon.sol";
import "./CityPanel.sol";
import "../Kohi/RandomV1.sol";

struct Parameters {
    uint8 width;
    uint8 height;
    Element element;
    Element[6] additionalElements;
    Language language;
    RenderMode renderMode;
    uint32 rootBG1;
    uint32 rootBG2;
    StarLight starLight;
    Moon moon;
    CityPanel[] shadowPanels;    
    CityPanel[] cityPanels;    
    RandomV1.PRNG prng;
}
