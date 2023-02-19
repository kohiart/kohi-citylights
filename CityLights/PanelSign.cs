// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using CityLights.Font;
using Kohi.Composer;

namespace CityLights;

public sealed class PanelSign
{
    public Color BgCol1;
    public Color BgCol2;
    public Color BgColText;
    public int H;
    public int TxtHeight;
    public int W;
    public string Word;
    public int X;
    public int Y;

    public PanelSign(PRNG prng, int x, int y, int w, int h, Color[] colors, string word, int scale)
    {
        X = x;
        Y = y;
        W = w;
        H = h;
        Word = word;

        var wd = w / scale;
        TxtHeight = RandomV1.Next(prng, wd - wd / 4, wd + 25) * scale; // increase the text size range

        BgCol1 = colors[RandomV1.Next(prng, colors.Length)];
        BgCol2 = colors[RandomV1.Next(prng, colors.Length)];
        BgColText = colors[RandomV1.Next(prng, 0, colors.Length)];
    }

    public void RenderPanelSignOutline(Graphics2D g, Matrix transform, RenderMode renderMode, int height, int scale,
        Color c)
    {
        var margin = .5f * scale;

        var boxLeft = (long) ((X + margin) * Fix64.One);
        var boxBottom = (long) ((Y + H + margin) * Fix64.One);
        var boxRight = (long) ((X + W - margin) * Fix64.One);
        var boxTop = (long) ((Y - margin) * Fix64.One);

        if (renderMode.Index == 2)
        {
            c = Color.FromArgb(225, 225, 225);

            var strokeWidth = 0.5f * scale;
            DrawRect(g, transform, height, strokeWidth, boxLeft, boxTop, boxRight, boxBottom, c);
        }
        else
        {
            var strokeWidth = 1 * scale;
            DrawRect(g, transform, height, strokeWidth, boxLeft, boxTop, boxRight, boxBottom, c);
        }
    }

    public void RenderPanelSignText(Graphics2D g, Matrix transform, TypeFace font, int height, int scale)
    {
        var emSizeInPoints = Fix64.Mul(TxtHeight * Fix64.One, 3221225472 /* 0.75 */);
        var styled = new StyledTypeFace(font, emSizeInPoints);
        var stringPrinter = new TypeFacePrinter(Word, styled); // 0.75 scales fonts to match Processing

        CalculateOrigin(stringPrinter);

        var bounds = new RectangleInt(X, Y, X + W, Y + H);

        if (scale > 1)
        {
            bounds.Left += (int) (scale / 2f);
            bounds.Right -= scale - 1;
            bounds.Top += scale - 1;
            bounds.Bottom -= 1;
        }

        stringPrinter.Render(g, BgColText, transform, height, bounds);
    }

    public Color RenderPanelSignGradient(Graphics2D g, Matrix transform, RenderMode renderMode, int height)
    {
        var c = GradientDraw.Draw(g, transform, renderMode, X, Y, W, H, BgCol1, BgCol2, height);
        return c;
    }

    private void CalculateOrigin(TypeFacePrinter stringPrinter)
    {
        var size = stringPrinter.GetSize(stringPrinter.Text);

        var origin = new Vector2(
            Fix64.Sub(
                Fix64.Add(
                    X * Fix64.One,
                    Fix64.Div(W * Fix64.One, Fix64.Two)
                ),
                Fix64.Div(size.X, Fix64.Two)
            ),
            Fix64.Add(
                Fix64.Sub(
                    Fix64.Add(
                        Y * Fix64.One,
                        H * Fix64.One
                    ),
                    Fix64.Div(H * Fix64.One, Fix64.Two)
                ),
                Fix64.Div(TxtHeight * Fix64.One, Fix64.Two)
            )
        );
        stringPrinter.Origin = origin;
    }

    private static void DrawRect(Graphics2D g, Matrix m, int height, float strokeWidth, long boxLeft, long boxTop,
        long boxRight,
        long boxBottom, Color c)
    {
        var tl = new Vector2(boxLeft, boxTop);
        var v0 = m.Transform(tl);
        v0 = new Vector2(v0.X, Fix64.Sub(height * Fix64.One, v0.Y));

        var tr = new Vector2(boxRight, boxTop);
        var v1 = m.Transform(tr);
        v1 = new Vector2(v1.X, Fix64.Sub(height * Fix64.One, v1.Y));

        var br = new Vector2(boxRight, boxBottom);
        var v2 = m.Transform(br);
        v2 = new Vector2(v2.X, Fix64.Sub(height * Fix64.One, v2.Y));

        var bl = new Vector2(boxLeft, boxBottom);
        var v3 = m.Transform(bl);
        v3 = new Vector2(v3.X, Fix64.Sub(height * Fix64.One, v3.Y));

        var line = new CustomPath();
        line.MoveTo(v0.X, v0.Y);
        line.LineTo(v1.X, v1.Y);
        line.LineTo(v2.X, v2.Y);
        line.LineTo(v3.X, v3.Y);
        line.LineTo(v0.X, v0.Y);

        var boxOutline = new Stroke(line.Vertices(), (long) (strokeWidth * Fix64.One));
        Graphics2D.Render(g, Stroke.Vertices(boxOutline).ToList(), c.ToUInt32());
    }
}