// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "./RenderPanel.sol";
import "./RenderPanelSign.sol";
import "./RenderPanelText.sol";

struct RenderPanels {
    RenderPanel[] shadow;
    RenderPanelSign[][] shadowSigns;
    RenderPanelText[][] shadowSignText;
    RenderPanel[] city;
    RenderPanelSign[][] citySigns;
    RenderPanelText[][] citySignText;
}
