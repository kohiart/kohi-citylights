// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using Kohi.Composer;

namespace CityLights.Font;

public struct GlyphInfo
{
    public int HorizontalAdvanceX;
    public string? Name = null!;
    public int Unicode;
    public CustomPath Vertices;

    public GlyphInfo()
    {
        HorizontalAdvanceX = 0;
        Name = null;
        Unicode = 0;
        Vertices = new CustomPath();
    }
}