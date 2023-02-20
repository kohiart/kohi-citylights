// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using Kohi.Composer;

namespace CityLights;

public sealed class CityLightsParameters
{
    public CityLightsParameters(PRNG prng, Artwork artwork)
    {
        var scale = artwork.Width / 1024;

        Element = (Element) RandomV1.Next(prng, 7);
        Language = (Language) RandomV1.Next(prng, 0, 2);
        RenderMode = RenderMode.Init(prng);

        var palettes = CityLightsPalette.InitSecondarySwatchData(this, prng);
        var palette = palettes[RandomV1.Next(prng, palettes.Length)];

        StarLight = StarLightDraw.Init(prng, (short) artwork.Width, (short) artwork.Height, scale);
        CityLightsMoon = CityLightsMoon.Init(prng, artwork.Width, artwork.Height, scale, palette);

        Words = WordList.Init(this);
        Sizes = SizeDistribution.Init(prng);
        ShadowPanels = CityPanel.InitShadowPanels(prng, artwork.Width, artwork.Height, scale, Sizes, CityLightsPalette.GetShadowPalette(), Words);
        CityPanels = CityPanel.InitCityPanels(prng, artwork.Width, artwork.Height, scale, Sizes, palette, Words);

        RootBg1 = palette[RandomV1.Next(prng, palette.Length)];
        RootBg2 = GetColor(0xFF121212);
    }

    public Element Element { get; set; }
    public Language Language { get; set; }
    public RenderMode RenderMode { get; set; }
    public string[] Words { get; set; }
    public int[] Sizes { get; set; }
    public StarLightDraw StarLight { get; set; }
    public CityLightsMoon CityLightsMoon { get; set; }
    public List<CityPanel> ShadowPanels { get; set; }
    public List<CityPanel> CityPanels { get; set; }
    public Color RootBg1 { get; set; }
    public Color RootBg2 { get; set; }
    public List<Element> AdditionalElements { get; set; } = new();

    private static Color GetColor(uint u)
    {
        return Color.FromArgb(
            (byte) (u >> 24),
            (byte) (u >> 16),
            (byte) (u >> 8), (byte) u);
    }
}