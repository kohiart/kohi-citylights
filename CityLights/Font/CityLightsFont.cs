// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Text.Json;
using Kohi.Composer;

namespace CityLights.Font;

public class CityLightsFont
{
    private static TypeFace _instance = null!;

    private static string FontJson => "font.json";

    public static TypeFace Instance
    {
        get
        {
            _instance = new TypeFace();

            var json = File.ReadAllText(FontJson);
            var font = JsonSerializer.Deserialize<FontInfo>(json)!;

            _instance.UnitsPerEm = font.UnitsPerEm;

            foreach (var stored in font.Glyphs)
            {
                var storage = new CustomPath(stored.Vertices.Count);

                foreach (var vertex in stored.Vertices) storage.Add(vertex.X, vertex.Y, vertex.Path);

                var glyph = new GlyphInfo
                {
                    Unicode = stored.Unicode,
                    HorizontalAdvanceX = stored.HorizontalAdvanceX,
                    Vertices = storage
                };

                _instance.Glyphs.Add(glyph.Unicode, glyph);
            }

            return _instance;
        }
    }
}