// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using CityLights.Font;
using Kohi.Composer;

namespace CityLights;

public sealed class CityPanelDraw
{
    public static void Draw(Graphics2D g, RenderMode renderMode,
        TypeFace font, int width, int height, int scale, List<CityPanel> blackPanels,
        List<CityPanel> cityPanels)
    {
        var transform = Matrix.Mul(
            Matrix.NewRotation(Fix64.Div(Fix64.Pi, 19327352832 /* 4.5 */)),
            Matrix.NewTranslation(
                Fix64.Div(width * Fix64.One, Fix64.Two),
                0
            )
        );

        foreach (var cp in blackPanels)
        {
            var colors = cp.RenderPanelBeforeText(g, transform, renderMode, height, scale);
            cp.RenderPanelText(g, font, transform, height, scale);
            cp.RenderPanelAfterText(g, transform, renderMode, height, scale, colors);
        }

        foreach (var cp in cityPanels)
        {
            var colors = cp.RenderPanelBeforeText(g, transform, renderMode, height, scale);
            cp.RenderPanelText(g, font, transform, height, scale);
            cp.RenderPanelAfterText(g, transform, renderMode, height, scale, colors);
        }
    }
}