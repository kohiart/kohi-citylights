// SPDX-License-Identifier: UNLICENSED
/* Copyright (c) 2021 eepmon. All rights reserved. */

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import "./IRenderer.sol";
import "./IAttributes.sol";
import "./ICityLightsParameters.sol";
import "./Parameters.sol";
import "./Errors.sol";

import "../Kohi/Graphics2D.sol";
import "../Kohi/Fix64.sol";
import "../Kohi/Ellipse.sol";

import "./GradientParams.sol";

import "./CityLightsGradient.sol";
import "./CityLightsStarLight.sol";
import "./CityLightsMoon.sol";
import "./CityLightsPanel.sol";

import "./CityLightsRender.sol";

interface ICityLightsRenderer is IERC165 {
    function image(Parameters memory parameters)
        external
        view
        returns (string memory);

    function render(
        uint256 tokenId,
        int32 seed,
        address parameters
    ) external view returns (uint8[] memory);
}

interface IImageRenderer {
    function render(
        uint256 tokenId,
        int32 seed,
        address parameters
    ) external view returns (uint8[] memory);
}

interface IImageEncoder {
    function imageUri(uint8[] memory buffer)
        external
        view
        returns (string memory);
}

contract CityLightsRenderer is Ownable, IRenderer, IAttributes, IERC165, ICityLightsRenderer {

    using Address for address;
    using ERC165Checker for address;

    ICityLightsParameters private _parameters;

    constructor() { }

    function setParameters(address parameters) external onlyOwner {
        _parameters = ICityLightsParameters(parameters);
    }

    function getAttributes(int32 seed) external view returns (string memory attributes) {
        uint8 numberOfTraits = 0;

        Parameters memory parameters = _parameters.getParameters(0, seed);
        
        attributes = string(abi.encodePacked('{"attributes":['));

        {
            (string memory a, uint8 t) = appendTrait(attributes, "Language", 
            string(abi.encodePacked(parameters.language == Language.En ? "EN" : "JP")), 
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            string memory environment;
            if(parameters.renderMode == RenderMode.Dark) {
                environment = "Dark";
            } else if(parameters.renderMode == RenderMode.City) {
                environment = "City";
            } else {
                environment = "Light";
            }
            (string memory a, uint8 t) = appendTrait(attributes, "Environment", 
            environment, 
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "Stars", 
            Strings.toString(parameters.starLight.starCount), 
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            string memory celestialObject;
            if(parameters.moon.mode == 0) {
                if(parameters.renderMode == RenderMode.Dark)
                    celestialObject = "Moon";
                else {
                    celestialObject = "Sun";
                }
            } else {
                if(parameters.renderMode == RenderMode.Dark)
                    celestialObject = "Glowing Moon";
                else {
                    celestialObject = "Radiant Sun";
                }
            }            
            (string memory a, uint8 t) = appendTrait(attributes, "Celestial Object", 
            celestialObject, 
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "Celestial Object Color", 
            toHtmlColorString(parameters.moon.color),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "Celestial Object Size", 
            Strings.toString(parameters.moon.size),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "Shadow Panels", 
            Strings.toString(parameters.shadowPanels.length),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "City Panels", 
            Strings.toString(parameters.cityPanels.length),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            uint panelSigns;                        
            for(uint i = 0; i < parameters.cityPanels.length; i++) {
                panelSigns += parameters.cityPanels[i].signs.length;
            }
            (string memory a, uint8 t) = appendTrait(attributes, "Panel Signs", 
            Strings.toString(panelSigns),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "Hatched Element", 
            toString(parameters.element),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "niban", 
            toString(parameters.additionalElements[0]),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "sanban", 
            toString(parameters.additionalElements[1]),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "yonban", 
            toString(parameters.additionalElements[2]),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "goban", 
            toString(parameters.additionalElements[3]),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        {
            (string memory a, uint8 t) = appendTrait(attributes, "rokuban", 
            toString(parameters.additionalElements[4]),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }
        
        {
            (string memory a, uint8 t) = appendTrait(attributes, "nanaban", 
            toString(parameters.additionalElements[5]),
            numberOfTraits
            );
            attributes = a;
            numberOfTraits = t;
        }

        return string(abi.encodePacked(attributes, "]}"));
    }
    
    function appendTrait(string memory attributes, string memory trait_type, string memory value, uint8 numberOfTraits) private pure returns (string memory, uint8) {        
        if(bytes(value).length > 0) {
            numberOfTraits++;
            attributes = string(abi.encodePacked(attributes, numberOfTraits > 1 ? ',' : '', '{"trait_type":"', trait_type, '","value":"', value, '"}'));
        }
        return (attributes, numberOfTraits);
    }

    function toString(Element element) internal pure returns (string memory) {
        if(element == Element.Fire) {
            return "Fire";
        } else if(element == Element.Water) {
            return "Water";
        } else if(element == Element.Earth) {
            return "Earth";
        } else if(element == Element.Wind) {
            return "Wind";
        } else if(element == Element.Wood) {
            return "Wood";
        } else if(element == Element.Metal) {
            return "Metal";
        } else /* if(parameters.element == Element.Hologram)*/ {
            return "Hologram";
        }  
    }

    bytes16 private constant _HEX_SYMBOLS = "0123456789ABCDEF";

    function toHtmlColorString(uint256 value) internal pure returns (string memory) {        
        bytes memory buffer = new bytes(9);         
        buffer[0] = "#";       
        uint i = 1;
        while(value != 0) {
            buffer[buffer.length - i] = _HEX_SYMBOLS[value & 0xf];
            i++;
            value >>= 4;
        }

        // ARGB => RGBA        
        bytes1 a1 = buffer[1];
        bytes1 a2 = buffer[2];        
        buffer[1] = buffer[3];
        buffer[2] = buffer[4];
        buffer[3] = buffer[5];
        buffer[4] = buffer[6];
        buffer[5] = buffer[7];
        buffer[6] = buffer[8];
        buffer[7] = a1;
        buffer[8] = a2;

        return string(buffer);
    }   

    IImageEncoder public encoder;
    bool public encoderLocked = false;

    function setEncoder(IImageEncoder _encoder) external onlyOwner {
        encoder = IImageEncoder(_encoder);
    }

    function lockEncoder() external onlyOwner {
        require(
            address(encoder).supportsInterface(type(IImageEncoder).interfaceId),
            "Not IImageEncoder"
        );
        encoderLocked = true;
    }

    CityLightsRender renderImpl;

    function setRenderer(CityLightsRender _render) external onlyOwner {
        renderImpl = CityLightsRender(_render);
    }

    function supportsInterface(bytes4 interfaceId)
        external
        pure
        override
        returns (bool)
    {
        return
            interfaceId == type(ICityLightsRenderer).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    function image(Parameters memory p)
        external
        view
        override
        returns (string memory)
    {
        require(address(encoder) != address(0), "No encoder");
        return encoder.imageUri(render_impl(p));
    }

    function render(
        uint256 tokenId,
        int32 seed,
        address parameters
    ) external view override returns (uint8[] memory) {
        return render_impl(ICityLightsParameters(parameters).getParameters(tokenId, seed));
    }

    function render(
        uint256 tokenId,
        int32 seed
    ) external view returns (uint8[] memory) {
        return render_impl(_parameters.getParameters(tokenId, seed));
    }

    function render_impl(Parameters memory p)
        private
        view
        returns (uint8[] memory)
    {
        return renderImpl.render(p);
    }

    function render(IRenderer.RenderArgs memory args)
        external
        pure
        returns (IRenderer.RenderArgs memory results)
    {
        
    }
}