// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using Kohi.Composer;

namespace CityLights.Font;

public class TypeFace
{
    public int UnitsPerEm;

    public Dictionary<int, GlyphInfo> Glyphs { get; } = new();

    internal CustomPath GetGlyphForCharacter(char character)
    {
        return !Glyphs.ContainsKey(character) ? null! : Glyphs[character].Vertices;
    }

    internal int GetAdvanceForCharacter(char character)
    {
        return !Glyphs.ContainsKey(character) ? 0 : Glyphs[character].HorizontalAdvanceX;
    }
}