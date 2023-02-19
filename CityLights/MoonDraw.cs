// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using Kohi.Composer;

namespace CityLights;

public static class MoonDraw
{
    public static void Draw(Graphics2D g, CityLightsMoon moon, int height, int scale)
    {
        switch (moon.Mode)
        {
            case 0:
            {
                DrawFilledCircle(g, moon.X, height - moon.Y, moon.Size, moon.Color);
                break;
            }
            case 1:
            {
                var moonGlow = Color.FromArgb(
                    25,
                    moon.Color.R,
                    moon.Color.G,
                    moon.Color.B);

                var mx = moon.X;
                var my = height - moon.Y;

                for (var i = 0; i < 15; i++)
                {
                    // This is actually more correct, with a much smoother gradient!
                    //
                    // We didn't ship with this, so it's here only for posterity.
                    //
                    // long step = i * Fix64.One;
                    // long bloom = Fix64.Mul(step, Fix64.Div(step, 4 * Fix64.One));
                    // long r = Fix64.Add(moon.size * Fix64.One, bloom);
                    // long hr = Fix64.Div(r, Fix64.Two);
                    // Graphics2D.Render(g, new Ellipse(mx * Fix64.One, my * Fix64.One, hr, hr).vertices().ToList(), moonGlow.ToUInt32());
                    //

                    var bloom = i * (i / 4) * scale;
                    DrawFilledCircle(g, mx, my, moon.Size + bloom, moonGlow);
                }

                DrawFilledCircle(g, mx, my, moon.Size, moon.Color);
                break;
            }
            default:
                throw new IndexOutOfRangeException();
        }
    }

    private static void DrawFilledCircle(Graphics2D g, int x, int y, int r, Color color)
    {
        Graphics2D.Render(g, new Ellipse(
                x * Fix64.One,
                y * Fix64.One,
                (long) (r / 2f * Fix64.One),
                (long) (r / 2f * Fix64.One)).Vertices().ToList(),
            color.ToUInt32());
    }
}