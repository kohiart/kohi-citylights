// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

using CityLights.Renderer;

const string outputDir = "renders";

await CommandLine.MastheadAsync();

var token = int.Parse(args[0]);
var seeds = Manifest.GetSeeds("manifest-citylights.txt");
var seed = seeds[token];

await RenderService.RenderAsync(outputDir, token, seed);