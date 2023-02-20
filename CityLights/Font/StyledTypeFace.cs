// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using Kohi.Composer;

namespace CityLights.Font;

public class StyledTypeFace
{
    private const int PointsPerInch = 72;
    private const int PixelsPerInch = 96;

    private readonly TypeFace _typeFace;

    public readonly long EmScaling;
    public readonly long EmSizeInPixels;

    public StyledTypeFace(TypeFace typeFace, long emSizeInPoints)
    {
        _typeFace = typeFace;

        EmSizeInPixels = Fix64.Mul(Fix64.Div(emSizeInPoints, PointsPerInch * Fix64.One), PixelsPerInch * Fix64.One);
        EmScaling = Fix64.Div(EmSizeInPixels, typeFace.UnitsPerEm * Fix64.One);
    }

    public IEnumerable<VertexData> GetGlyphForCharacter(char character)
    {
        var sourceGlyph = _typeFace.GetGlyphForCharacter(character);
        {
            var transform = Matrix.NewIdentity();
            transform *= Matrix.NewScale(EmScaling);
            var vertices = ApplyTransformMethods.ApplyTransform(sourceGlyph.Vertices().ToList(), transform);
            vertices = FlattenCurves.Flatten(vertices);
            return vertices;
        }
    }

    public long GetAdvanceForCharacter(string line, int index)
    {
        return Fix64.Mul(_typeFace.GetAdvanceForCharacter(line[index]) * Fix64.One, EmScaling);
    }
}