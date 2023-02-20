// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using Kohi.Composer;

namespace CityLights.Font;

public class TypeFacePrinter
{
    public Justification Justification;
    public Vector2 Origin;
    public StyledTypeFace Style;
    public string Text;

    public TypeFacePrinter(string text, StyledTypeFace style, Vector2 origin = default,
        Justification justification = Justification.Left)
    {
        Style = style;
        Text = text;
        Justification = justification;
        Origin = origin;
    }

    public void Render(Graphics2D g, Color color, Matrix m, int yShift, RectangleInt bounds)
    {
        SetClippingBox(g.ClippingData, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, m, yShift);

        var vertexGroups = VertexGroups().ToList();
        foreach (var vertexGroup in vertexGroups)
            Graphics2D.RenderWithYShift(g, vertexGroup, color, m, yShift);

        NoClippingBox(g.ClippingData);
    }

    public static void NoClippingBox(ClippingData clippingData)
    {
        clippingData.ClipPoly = null;
    }

    public static void SetClippingBox(ClippingData clippingData, int left, int top, int right, int bottom,
        Matrix transform, int height)
    {
        var tl = transform.Transform(new Vector2(left * Fix64.One, top * Fix64.One));
        var tr = transform.Transform(new Vector2(right * Fix64.One, top * Fix64.One));
        var br = transform.Transform(new Vector2(right * Fix64.One, bottom * Fix64.One));
        var bl = transform.Transform(new Vector2(left * Fix64.One, bottom * Fix64.One));

        clippingData.ClipPoly = new Vector2[4];
        clippingData.ClipPoly[0] = new Vector2(tl.X, Fix64.Sub(height * Fix64.One, tl.Y));
        clippingData.ClipPoly[1] = new Vector2(tr.X, Fix64.Sub(height * Fix64.One, tr.Y));
        clippingData.ClipPoly[2] = new Vector2(br.X, Fix64.Sub(height * Fix64.One, br.Y));
        clippingData.ClipPoly[3] = new Vector2(bl.X, Fix64.Sub(height * Fix64.One, bl.Y));
    }

    public IEnumerable<VertexData[]> VertexGroups()
    {
        var vertexGroups = new List<VertexData[]>();

        if (string.IsNullOrEmpty(Text))
            return vertexGroups;

        var currentOffset = new Vector2(0, 0);

        for (var currentChar = 0; currentChar < Text.Length; currentChar++)
        {
            var vertexGroup = new List<VertexData>();

            var character = Text[currentChar];
            var currentGlyph = Style.GetGlyphForCharacter(character).ToList();

            foreach (var vertexData in currentGlyph)
            {
                switch (vertexData.Command)
                {
                    case Command.Stop:
                        continue;
                    case Command.EndPoly:
                        vertexGroup.Add(new VertexData(Command.EndPoly, 0, 0));
                        continue;
                }

                var position = vertexData.Position;

                // FLIP_Y
                position = new Vector2(position.X, -1 * position.Y);

                var offsetVertex = new VertexData(vertexData.Command,
                    position + currentOffset + Origin);

                vertexGroup.Add(offsetVertex);
            }

            // get the advance for the next character
            currentOffset.X = Fix64.Add(currentOffset.X, Style.GetAdvanceForCharacter(Text, currentChar));

            vertexGroups.Add(vertexGroup.ToArray());
        }

        return vertexGroups;
    }

    public Vector2 GetSize(string text)
    {
        var offset = new Vector2
        {
            X = 0,
            Y = Style.EmSizeInPixels
        };

        long currentLineX = 0;

        for (var i = 0; i < text.Length; i++)
        {
            currentLineX = Fix64.Add(currentLineX, Style.GetAdvanceForCharacter(text, i));

            if (currentLineX > offset.X)
            {
                offset.X = currentLineX;
            }
        }

        return offset;
    }
}