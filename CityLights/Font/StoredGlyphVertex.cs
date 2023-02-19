// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Text.Json.Serialization;
using Kohi.Composer;

namespace CityLights.Font;

public sealed class StoredGlyphVertex
{
    [JsonPropertyName("x")] public long X { get; set; }

    [JsonPropertyName("y")] public long Y { get; set; }

    [JsonPropertyName("path")] public Command Path { get; set; }
}