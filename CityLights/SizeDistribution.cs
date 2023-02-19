// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using Kohi.Composer;

namespace CityLights;

public class SizeDistribution
{
    public static int[] Init(PRNG prng)
    {
        var sizes = new int[10];

        for (var i = 0; i < 10; i++)
            if (i % 4 == 0)
                sizes[i] = RandomV1.Next(prng, 35, 75); // med
            else if (i % 9 == 0)
                sizes[i] = RandomV1.Next(prng, 75, 150); // big
            else
                sizes[i] = RandomV1.Next(prng, 5, 35); // tiny

        return sizes;
    }
}