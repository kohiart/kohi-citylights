// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.13;

import "./InflateLib.sol";
import "./SSTORE2.sol";

error FailedToDecompress(uint256 errorCode);
error InvalidDecompressionLength(uint256 expected, uint256 actual);

library BufferUtils {
    function decompress(address compressed, uint256 decompressedLength)
        internal
        view
        returns (bytes memory)
    {
        (InflateLib.ErrorCode code, bytes memory buffer) = InflateLib.puff(
            SSTORE2.read(compressed),
            decompressedLength
        );
        if (code != InflateLib.ErrorCode.ERR_NONE)
            revert FailedToDecompress(uint256(code));
        if (buffer.length != decompressedLength)
            revert InvalidDecompressionLength(
                decompressedLength,
                buffer.length
            );
        return buffer;
    }

    function readByte(uint256 position, bytes memory buffer)
        internal
        pure
        returns (uint8, uint256)
    {
        uint8 value = uint8(buffer[position++]);
        return (value, position);
    }

    function readInt32(uint256 position, bytes memory buffer)
        internal
        pure
        returns (int32, uint256)
    {
        uint8 d1 = uint8(buffer[position++]);
        uint8 d2 = uint8(buffer[position++]);
        uint8 d3 = uint8(buffer[position++]);
        uint8 d4 = uint8(buffer[position++]);
        return (
            int32((0x1000000 * d4) + (0x10000 * d3) + (0x100 * d2) + d1),
            position
        );
    }

    function readUInt32(uint256 position, bytes memory buffer)
        internal
        pure
        returns (uint32, uint256)
    {
        uint8 d1 = uint8(buffer[position++]);
        uint8 d2 = uint8(buffer[position++]);
        uint8 d3 = uint8(buffer[position++]);
        uint8 d4 = uint8(buffer[position++]);
        return (
            uint32((0x1000000 * d4) + (0x10000 * d3) + (0x100 * d2) + d1),
            position
        );
    }

    function readUInt64(uint256 position, bytes memory buffer)
    internal
    pure
    returns (uint64, uint256)
    {
        uint8 d1 = uint8(buffer[position++]);
        uint8 d2 = uint8(buffer[position++]);
        uint8 d3 = uint8(buffer[position++]);
        uint8 d4 = uint8(buffer[position++]);
        uint8 d5 = uint8(buffer[position++]);
        uint8 d6 = uint8(buffer[position++]);
        uint8 d7 = uint8(buffer[position++]);
        uint8 d8 = uint8(buffer[position++]);
        return ((72057594037927936 * d8) + (281474976710656 * d7) + (1099511627776 * d6) + (4294967296 * d5) + (16777216 * d4) + (65536 * d3) + (256 * d2) + d1, position);
    }

    function readInt64(uint256 position, bytes memory buffer)
    internal
    pure
    returns (int64, uint256)
    {
        uint8 d1 = uint8(buffer[position++]);
        uint8 d2 = uint8(buffer[position++]);
        uint8 d3 = uint8(buffer[position++]);
        uint8 d4 = uint8(buffer[position++]);
        uint8 d5 = uint8(buffer[position++]);
        uint8 d6 = uint8(buffer[position++]);
        uint8 d7 = uint8(buffer[position++]);
        uint8 d8 = uint8(buffer[position++]);
        return (
            int64((72057594037927936 * d8) + (281474976710656 * d7) + (1099511627776 * d6) + (4294967296 * d5) + (16777216 * d4) + (65536 * d3) + (256 * d2) + d1), 
            position
        );
    }
}
