// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

namespace CityLights.Font;

public sealed class FontInfo
{
    public int UnitsPerEm { get; set; }
    public List<StoredGlyph> Glyphs { get; set; } = new();
}