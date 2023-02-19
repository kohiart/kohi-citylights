const fs = require('fs');
const quiet = false;
const GLYPH_DIR = "./font/";

task("deploy", "Deploy contract to network")
    .setAction(async (taskArgs, hre) => {
        await deployAll();
    });

async function deployAll() {
    let networkName = network.name;
    if (network.chainId == 8134646) {
        networkName = "mochi";
    } else if (network.chainId == 1337) {
        networkName = "hardhat";
    }

    console.log();
    console.log("Network:");
    console.log("------------------------------------------------------------------------");
    console.log(networkName);

    console.log();
    console.log("Kohi:");
    console.log("------------------------------------------------------------------------");
    let kohi = await deployKohi();

    console.log();
    console.log("City Lights:");
    console.log("------------------------------------------------------------------------");
    let cityLights = await deployCityLights(kohi);

    console.log();
    console.log("Manifest:");
    console.log("------------------------------------------------------------------------");
    let manifest = mergeJSON(kohi, cityLights);

    let output = outputManifest(manifest);
    console.log(output);

    fs.writeFileSync(`../CityLights.Renderer/manifest-${networkName}.json`, JSON.stringify(output));

    await deployGlyphs(manifest, quiet);
}

async function deployKohi() {
    let manifest = {};
    await deployContract(manifest, "SinLut256");
    await deployContract(manifest, "EllipseMethods", {
        libraries: {
            SinLut256: manifest.SinLut256.address
        },
    });
    await deployContract(manifest, "CustomPathMethods");
    await deployContract(manifest, "StrokeMethods", {
        libraries: {
            SinLut256: manifest.SinLut256.address
        }
    });
    await deployContract(manifest, "AntiAliasMethods");
    await deployContract(manifest, "CellBlockMethods");
    await deployContract(manifest, "CellDataMethods", {
        libraries: {
            CellBlockMethods: manifest.CellBlockMethods.address
        }
    });
    await deployContract(manifest, "ClippingDataMethods");
    await deployContract(manifest, "ScanlineDataMethods");
    await deployContract(manifest, "SubpixelScaleMethods");
    await deployContract(manifest, "Graphics2DMethods", {
        libraries: {
            AntiAliasMethods: manifest.AntiAliasMethods.address,
            CellDataMethods: manifest.CellDataMethods.address,
            ClippingDataMethods: manifest.ClippingDataMethods.address,
            ScanlineDataMethods: manifest.ScanlineDataMethods.address,
            SubpixelScaleMethods: manifest.SubpixelScaleMethods.address,
        }
    });
    return manifest;
}

async function deployCityLights(kohi) {
    let manifest = {};
    await deployContract(manifest, "Earth");
    await deployContract(manifest, "Fire");
    await deployContract(manifest, "Hologram");
    await deployContract(manifest, "Metal");
    await deployContract(manifest, "Water");
    await deployContract(manifest, "Wind");
    await deployContract(manifest, "Wood");
    await deployContract(manifest, "English");
    await deployContract(manifest, "Japanese");   
    await deployContract(manifest, "CityLightsPanels");
    await deployContract(manifest, "CityLightsPalette", {
        libraries: {
            Earth: manifest.Earth.address,
            Fire: manifest.Fire.address,
            Hologram: manifest.Hologram.address,
            Metal: manifest.Metal.address,
            Water: manifest.Water.address,
            Wind: manifest.Wind.address,
            Wood: manifest.Wood.address
        }
    });
    await deployContract(manifest, "CityLightsMoonFactory", {
        libraries: {
            EllipseMethods: kohi.EllipseMethods.address
        }
    });
    await deployContract(manifest, "CityLightsStarLightFactory", {
        libraries: {
            EllipseMethods: kohi.EllipseMethods.address
        }
    });
    await deployContract(manifest, "CityLightsParameters", {
        libraries: {
            CityLightsMoonFactory: manifest.CityLightsMoonFactory.address,
            CityLightsPalette: manifest.CityLightsPalette.address,
            CityLightsPanels: manifest.CityLightsPanels.address,
            CityLightsStarLightFactory: manifest.CityLightsStarLightFactory.address,
            English: manifest.English.address,
            Japanese: manifest.Japanese.address
        }
    });    
    await deployContract(manifest, "CityLightsGradientFactory", {
        libraries: {
            CustomPathMethods: kohi.CustomPathMethods.address,
            StrokeMethods: kohi.StrokeMethods.address,
        }
    });
    await deployContract(manifest, "CityLightsGradient");    
    await deployContract(manifest, "CityLightsPanelFactory", {
        libraries: {
            CityLightsGradientFactory: manifest.CityLightsGradientFactory.address,
            CustomPathMethods: kohi.CustomPathMethods.address,
            StrokeMethods: kohi.StrokeMethods.address
        }
    });
    await deployContract(manifest, "CityLightsPanel");
    await deployContract(manifest, "CityLightsPanelSignFactory", {
        libraries: {
            CityLightsGradientFactory: manifest.CityLightsGradientFactory.address,
            CustomPathMethods: kohi.CustomPathMethods.address,
            StrokeMethods: kohi.StrokeMethods.address
        }
    });
    await deployContract(manifest, "CityLightsStarLight");
    await deployContract(manifest, "CityLightsMoon");
    await deployContract(manifest, "CityLightsClipping");
    await deployContract(manifest, "CityLightsRender", {
        libraries: {
            Graphics2DMethods: kohi.Graphics2DMethods.address,
            SinLut256: kohi.SinLut256.address,
            CityLightsStarLight: manifest.CityLightsStarLight.address,
            CityLightsStarLightFactory: manifest.CityLightsStarLightFactory.address,
            CityLightsGradient: manifest.CityLightsGradient.address,
            CityLightsGradientFactory: manifest.CityLightsGradientFactory.address,
            CityLightsMoon: manifest.CityLightsMoon.address,
            CityLightsMoonFactory: manifest.CityLightsMoonFactory.address,
            CityLightsPanelFactory: manifest.CityLightsPanelFactory.address,
            CityLightsPanelSignFactory: manifest.CityLightsPanelSignFactory.address,
            CityLightsPanel: manifest.CityLightsPanel.address,
            CityLightsClipping: manifest.CityLightsClipping.address
        }
    });
    await deployContract(manifest, "CityLightsRenderer");

    await deployContract(manifest, "CityLightsFont");

    let fontTx = await manifest.CityLightsRender.setFont(manifest.CityLightsFont.address);
    await fontTx.wait();
    console.log(`Set font to ${manifest.CityLightsFont.address}`);

    let setParametersTx = await manifest.CityLightsRenderer.setParameters(manifest.CityLightsParameters.address);
    await setParametersTx.wait();
    console.log(`Set parameter contract to ${manifest.CityLightsRenderer.address}`);

    let setRendererTx = await manifest.CityLightsRenderer.setRenderer(manifest.CityLightsRender.address);
    await setRendererTx.wait();
    console.log(`Set render implementation to ${manifest.CityLightsRender.address}`);

    return manifest;
}

async function deployGlyphs(manifest, quiet) {
    var glyphsToSet = [];
    const files = fs.readdirSync(GLYPH_DIR);
    files.forEach(function (file) {
        if (file.endsWith("zip")) {
            var uncompressed = file.replace("zip", "bin");
            var length = fs.statSync(`${GLYPH_DIR}/${uncompressed}`).size;
            var filePath = `${GLYPH_DIR}/${file}`;
            var codepointString = file.replace(".zip", "").substring(file.indexOf("_") + 1);
            var codepoint = parseInt(codepointString);
            var buffer = fs.readFileSync(filePath);
            var glyphToSet = { codepoint: codepoint, length: length, buffer: buffer, name: file };
            glyphsToSet.push(glyphToSet);
        }
    });
    glyphsToSet = glyphsToSet.sort((a, b) => a.codepoint - b.codepoint);
    if (!quiet) console.log(`Found ${glyphsToSet.length} glyphs.`);
    const gwei = 10;
    var totalCost = 0;
    for (var i = 0; i < glyphsToSet.length; i++) {
        var tx = await manifest.CityLightsFont.setGlyph(glyphsToSet[i].codepoint, glyphsToSet[i].length, glyphsToSet[i].buffer);
        const receipt = await tx.wait();
        var cost = (receipt.gasUsed * gwei) * .000000001;
        totalCost += cost;
        if (!quiet) console.log(`#${glyphsToSet[i].codepoint} (${glyphsToSet[i].name}) (${i + 1} / ${glyphsToSet.length})`);
    }
    if (!quiet) console.log(`Deployed ${glyphsToSet.length} glyphs.`);
    if (!quiet) console.log(`Total cost in ETH assuming ${gwei} gas: ${totalCost}`);
}

async function deployContract(manifest, contractName, libraries) {
    let contract = {};
    if (libraries) {
        contract = await ethers.getContractFactory(contractName, libraries);
    } else {
        contract = await ethers.getContractFactory(contractName);
    }
    var deployed = await contract.deploy();
    await deployed.deployed();
    console.log(`${contractName} deployed to: ${deployed.address}`);
    manifest[contractName] = deployed;
}

function outputManifest(manifest) {
    var output = {};
    for (var property in manifest) {
        if (manifest[property].address) {
            output[property] = manifest[property].address;
        }
    }
    return output;
}

function mergeJSON(json1, json2) {
    var result = {};
    for (var prop in json1) {
        result[prop] = json1[prop];
    }
    for (var prop in json2) {
        result[prop] = json2[prop];
    }
    return result;
}