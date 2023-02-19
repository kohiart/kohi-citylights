// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using Kohi.Composer;

namespace CityLights;

public class StarLightDraw
{
    public static readonly int MaxStars = 50;
    public int NumStars;
    public List<Star> Stars = null!;

    public static StarLightDraw Init(PRNG prng, short width, short height, int scale)
    {
        var result = new StarLightDraw();
        result.NumStars = RandomV1.Next(prng, 0, MaxStars);
        result.Stars = new List<Star>();

        for (var i = 0; i < result.NumStars; i++)
        {
            var s = new Star(
                RandomV1.Next(prng, 0, width),
                RandomV1.Next(prng, 0, height),
                RandomV1.Next(prng, 1 * scale, 3 * scale));
            result.Stars.Add(s);
        }

        return result;
    }

    public static void Draw(Graphics2D g, StarLightDraw starLight)
    {
        var color = Color.White.ToUInt32();

        for (var i = 0; i < starLight.NumStars; i++)
        {
            var star = starLight.Stars[i];
            var x = star.X * Fix64.One;
            var y = star.Y * Fix64.One;
            var s = Fix64.Div(star.S * Fix64.One, Fix64.Two);

            Graphics2D.Render(g, new Ellipse(
                x,
                y,
                s,
                s
            ).Vertices().ToList(), color);
        }
    }
}