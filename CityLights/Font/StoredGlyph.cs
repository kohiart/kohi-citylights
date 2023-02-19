// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Text.Json.Serialization;

namespace CityLights.Font;

public sealed class StoredGlyph
{
    [JsonPropertyName("unicode")] public int Unicode { get; set; }

    [JsonPropertyName("horizontal_advance_x")]
    public int HorizontalAdvanceX { get; set; }

    [JsonPropertyName("vertices")] public List<StoredGlyphVertex> Vertices { get; set; } = new();
}