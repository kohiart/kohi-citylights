// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using CityLights.Font;
using Kohi.Composer;

namespace CityLights;

public sealed class CityPanel
{
    private const int MinNumSigns = 5;
    private const int MaxNumSigns = 40;
    private const int MinShadowPanels = 10;
    private const int MaxShadowPanels = 50;

    private const int MinCityPanels = 30;
    private const int MaxCityPanels = 115;

    private const int VSpc = 3;
    private const int Pivot = 1;
    private readonly List<PanelSign> _signs;

    public Color BgCol1;
    public Color BgCol2;
    public int H;
    public int Id;
    public int W;
    public int X;
    public int Y;

    public CityPanel(PRNG prng, int id, int x, int y, int w, int scale, Color[] palette, string[] wordList)
    {
        Id = id;
        X = x;
        Y = y;
        W = w;

        BgCol1 = palette[RandomV1.Next(prng, palette.Length)];
        BgCol2 = palette[RandomV1.Next(prng, palette.Length)];
        SignCount = RandomV1.Next(prng, MinNumSigns, MaxNumSigns);

        var minSignHeight = 15;
        var maxSignHeight = Math.Max(minSignHeight, w / scale);
        var totalSignsHeight = 0;

        var scaledVerticalSpacing = VSpc * scale;

        _signs = new List<PanelSign>();
        for (var i = 0; i < SignCount; i++)
        {
            var word = wordList[RandomV1.Next(prng, 0, wordList.Length)];
            var sign = CreatePanelSign(prng, _signs, i, palette, word, minSignHeight, maxSignHeight, scale);
            _signs.Add(sign);
            totalSignsHeight += sign.H + scaledVerticalSpacing;
        }

        H = totalSignsHeight + 1 * scale;
    }

    public int SignCount { get; }

    private PanelSign CreatePanelSign(PRNG prng, List<PanelSign> signs, int i, Color[] bgCols, string word,
        int minSignHeight, int maxSignHeight, int scale)
    {
        var scaledPivot = Pivot * scale;
        var scaledVerticalSpacing = VSpc * scale;

        var px = X + scaledPivot;
        var pw = W - 2 * scale;

        if (i > 0)
        {
            var signH = RandomV1.Next(prng, minSignHeight, maxSignHeight) * scale;
            var previous = signs[i - 1];
            var py = previous.Y + previous.H + scaledVerticalSpacing;
            return new PanelSign(prng, px, py, pw, signH, bgCols, word, scale);
        }

        return new PanelSign(prng, px, Y + scaledPivot, pw, 10 * scale, bgCols, word, scale);
    }

    public static List<CityPanel> InitShadowPanels(PRNG prng, int width, int height, int scale, int[] sizes,
        Color[] colors, string[] words)
    {
        var panels = new List<CityPanel>();
        var panelCount = RandomV1.Next(prng, MinShadowPanels, MaxShadowPanels);

        for (var i = 0; i < panelCount; i++)
        {
            var x = RandomV1.Next(prng, 100, width / scale - 100) * scale;
            var y = RandomV1.Next(prng, 0, height / scale / 2) * scale;
            var w = sizes[RandomV1.Next(prng, sizes.Length - 1)] * scale; // IMPORTANT: don't pick last element!

            var cp = new CityPanel(prng, i, x, y, w, scale, colors, words);
            panels.Add(cp);
        }

        return panels;
    }

    public static List<CityPanel> InitCityPanels(PRNG prng, int width, int height, int scale, int[] sizes,
        Color[] colors,
        string[] words)
    {
        var panels = new List<CityPanel>();
        var panelCount = RandomV1.Next(prng, MinCityPanels, MaxCityPanels);

        for (var i = 0; i < panelCount; i++)
        {
            var x = RandomV1.Next(prng, 0, width / scale / 2 + 100) * scale;
            var y = RandomV1.Next(prng, 0, height / scale - height / scale / 3) * scale;
            var s = sizes[RandomV1.Next(prng, sizes.Length - 1)] * scale; // IMPORTANT: don't pick last element!

            var cp = new CityPanel(prng, i, x, y, s, scale, colors, words);
            panels.Add(cp);
        }

        return panels;
    }

    public Color[] RenderPanelBeforeText(Graphics2D g, Matrix m, RenderMode r, int height, int scale)
    {
        RenderPanelGradient(g, m, r, height);
        return RenderPanelSignsBeforeText(g, m, r, height, scale);
    }

    public void RenderPanelText(Graphics2D g, TypeFace font, Matrix m, int height, int scale)
    {
        for (var i = 0; i < SignCount; i++) _signs[i].RenderPanelSignText(g, m, font, height, scale);
    }

    public void RenderPanelAfterText(Graphics2D g, Matrix m, RenderMode r, int height, int scale, Color[] colors)
    {
        for (var i = 0; i < SignCount; i++)
            _signs[i].RenderPanelSignOutline(g, m, r, height, scale, colors[i]);

        RenderPanelOutline(g, m, r, height, scale);
    }

    private Color[] RenderPanelSignsBeforeText(Graphics2D g, Matrix m, RenderMode r, int height, int scale)
    {
        var colors = new List<Color>();
        for (var i = 0; i < SignCount; i++)
        {
            var c = _signs[i].RenderPanelSignGradient(g, m, r, height);
            colors.Add(c);
        }

        return colors.ToArray();
    }

    private void RenderPanelOutline(Graphics2D g, Matrix m, RenderMode r, int height, int scale)
    {
        var c = ApplyRenderMode(r, Color.Black);

        var margin = .5f * scale;
        var left = X - 1 * scale + margin;
        var bottom = Y - 1 * scale + H + 2 * scale + margin;
        var right = X - 1 * scale + W + 2 * scale - margin;
        var top = Y - 1 * scale - margin;

        var boxLeft = (long) (left * Fix64.One);
        var boxBottom = (long) (bottom * Fix64.One);
        var boxRight = (long) (right * Fix64.One);
        var boxTop = (long) (top * Fix64.One);

        DrawRect(g, m, height, scale, boxLeft, boxTop, boxRight, boxBottom, c);
    }

    private void RenderPanelGradient(Graphics2D g, Matrix m, RenderMode r, int height)
    {
        GradientDraw.Draw(g, m, r, X, Y, W, H, BgCol1, BgCol2, height);
    }

    private static void DrawRect(Graphics2D g, Matrix m, int height, int scale, long boxLeft, long boxTop,
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

        var strokeWidth = 1.5f * scale;
        var outline = new Stroke(line.Vertices(), (long) (strokeWidth * Fix64.One));
        var vertices = Stroke.Vertices(outline).ToList();
        Graphics2D.Render(g, vertices, c.ToUInt32());
    }

    public static Color ApplyRenderMode(RenderMode renderMode, Color c)
    {
        return renderMode.Index switch
        {
            0 => Color.Black,
            1 => c,
            2 => Color.White,
            _ => throw new IndexOutOfRangeException()
        };
    }
}