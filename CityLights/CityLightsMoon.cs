// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using Kohi.Composer;

namespace CityLights;

public class CityLightsMoon
{
    public Color Color;
    public int Mode;
    public int Size;
    public int X;
    public int Y;

    public static CityLightsMoon Init(PRNG prng, int width, int height, int scale, Color[] palette)
    {
        var moon = new CityLightsMoon
        {
            Mode = RandomV1.Next(prng, 0, 2), // values are either 0 or 1
            Size = RandomV1.Next(prng, 100, 300) * scale
        };

        moon.X = RandomV1.Next(prng, moon.Size / scale / 2, width / scale - moon.Size / scale / 2) * scale;

        var minY = moon.Size / scale;
        var maxY = height / scale / 4 - minY / 4;
        var min = Math.Min(minY, maxY);
        var max = Math.Max(minY, maxY);
        moon.Y = RandomV1.Next(prng, min, max) * scale;

        moon.Color = palette[RandomV1.Next(prng, palette.Length)];
        return moon;
    }
}