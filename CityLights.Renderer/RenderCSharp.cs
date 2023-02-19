// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Numerics;
using CityLights.Font;
using Kohi.Composer;

namespace CityLights.Renderer;

internal class RenderCSharp
{
    public static Task<string> ExecuteAsync(string folder, BigInteger token, int seed)
    {
        var artwork = new Artwork(seed, CityLightsFont.Instance);
        var graphics = new Graphics2D(artwork.Width, artwork.Height);
        artwork.Draw(graphics, 1);
        var filename = Path.Combine(folder, $"CityLights_CSharp_{token}_{seed}.png");
        ImageData.Save(filename, graphics);
        return Task.FromResult(filename);
    }
}