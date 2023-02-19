// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using CityLights.Font;
using Kohi.Composer;

namespace CityLights;

public class Artwork
{
    public Artwork(int seed, TypeFace font, int width = 1024, int height = 1280)
    {
        Width = width;
        Height = height;
        var prng = RandomV1.BuildSeedTable(seed);
        Parameters = new CityLightsParameters(prng, this);
        Font = font;
    }

    public TypeFace Font { get; set; }

    public CityLightsParameters Parameters { get; set; }
    public int Width { get; }

    public int Height { get; }

    public void Draw(Graphics2D g, int scale)
    {
        Graphics2D.Clear(g, Color.Black.ToUInt32());
        GradientDraw.Draw(g, Parameters.RenderMode, 0, 0, Width, Height, Parameters.RootBg1, Parameters.RootBg2);
        StarLightDraw.Draw(g, Parameters.StarLight);
        MoonDraw.Draw(g, Parameters.CityLightsMoon, Height, scale);
        CityPanelDraw.Draw(g, Parameters.RenderMode, Font, Width, Height, scale, Parameters.ShadowPanels,
            Parameters.CityPanels);
    }
}