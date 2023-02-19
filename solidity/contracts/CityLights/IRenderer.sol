// SPDX-License-Identifier: MIT
/* Copyright (c) Kohi Art Community, Inc. All rights reserved. */

/*
/*
///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//     @@@@@@@@@@@@@@                        @@@@                                // 
//               @@@@                        @@@@ @@@@@@@@                       // 
//               @@@@    @@@@@@@@@@@@@@@@    @@@@@@@          @@@@@@@@@@@@@@@@   // 
//               @@@@                        @@@@                                // 
//     @@@@@@@@@@@@@@                        @@@@@@@@@@@@@                       // 
//               @@@@                          @@@@@@@@@@@                       // 
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////
*/

pragma solidity ^0.8.13;

import "../Kohi/RandomV1.sol";

/// @dev This is the legacy V1 renderer, which assumed batched rendering

interface IRenderer {

    struct RenderArgs {
        int16 index;
        uint8 stage;
        int32 seed;        
        uint32[20480] buffer;
        RandomV1.PRNG prng;
    }

    /**
     * @notice Renders a chunk of the artwork, given an index.
     * @dev The output is an array of packed uint32s, in ARGB format.     
     */
    function render(RenderArgs memory args) external view returns (RenderArgs memory results);
}
