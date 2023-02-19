// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using System.Drawing;
using Kohi.Composer;

namespace CityLights;

public static class GradientDraw
{
    public static Color Draw(Graphics2D g, Matrix m, RenderMode r, int x, int y, float w, float h, Color c1,
        Color c2, int height)
    {
        var c = Color.Red;
        for (float i = y; i <= y + h; i += 0.25f)
        {
            var interF = Fix64.Map((long) (i * Fix64.One), y * Fix64.One,
                Fix64.Add(y * Fix64.One, (long) (h * Fix64.One)), 0, Fix64.One);

            c = ColorMath.Lerp(c1.ToUInt32(), c2.ToUInt32(), interF).ToColor();
            c = ApplyRenderMode(r, c);

            var v0 = m.Transform(new Vector2(x * Fix64.One, (long) (i * Fix64.One)));
            var v1 = m.Transform(new Vector2((long) ((x + w) * Fix64.One), (long) (i * Fix64.One)));

            v0 = new Vector2(v0.X, Fix64.Sub(height * Fix64.One, v0.Y));
            v1 = new Vector2(v1.X, Fix64.Sub(height * Fix64.One, v1.Y));

            var line = new CustomPath();
            line.MoveTo(v0.X, v0.Y);
            line.LineTo(v1.X, v1.Y);
            var stroke = new Stroke(line.Vertices());
            Graphics2D.Render(g, Stroke.Vertices(stroke).ToList(), c.ToUInt32());
        }

        return c;
    }

    public static void Draw(Graphics2D g, RenderMode r, int x, int y, float w, float h, Color c1, Color c2)
    {
        var yF = y * Fix64.One;
        var hF = (long) (h * Fix64.One);
        var xF = x * Fix64.One;
        var wF = (long) (w * Fix64.One);

        for (var i = yF; i <= yF + hF; i += 1073741824 /* 0.25 */)
        {
            var inter = Fix64.Map(i, yF, Fix64.Add(yF, hF), 0, Fix64.One);
            var c = ColorMath.Lerp(c1.ToUInt32(), c2.ToUInt32(), inter).ToColor();
            c = ApplyRenderMode(r, c);

            var line = new CustomPath();
            line.MoveTo(xF, Fix64.Sub(hF, i));
            line.LineTo(Fix64.Add(xF, wF), Fix64.Sub(hF, i));
            var stroke = new Stroke(line.Vertices());
            Graphics2D.Render(g, Stroke.Vertices(stroke).ToList(), c.ToUInt32());
        }
    }

    public static Color ApplyRenderMode(RenderMode renderMode, Color c)
    {
        return renderMode.Index switch
        {
            0 => Color.Black,
            1 => c,
            2 => Color.White,
            _ => throw new ArgumentOutOfRangeException()
        };
    }
}