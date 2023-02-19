// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using Kohi.Composer;

namespace CityLights;

public class RenderMode
{
    public int Index;

    public static RenderMode Init(PRNG prng)
    {
        var result = new RenderMode
        {
            Index = RandomV1.Next(prng, 0, 2)
        };
        if (RandomV1.Next(prng, 0, 30) == 7) result.Index = 2;
        return result;
    }
}