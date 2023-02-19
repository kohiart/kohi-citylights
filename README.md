# CityLights by eepmon

### Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

- Website: https://eepmon.com/
- Twitter: https://twitter.com/eepmon
- Gallery: https://kohi.art/collections/citylights

```
/*                                                                                
                                     &@@@@@@@@@@@        @@@@@@@@@@@@@@         
                                 @@@@@@@@@@@@@@@@@@%  @@@@@@@@@@@@@@@@@@@@      
           @@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@    
     /@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&   #@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@    
    @@@@@@@@@@@   (@@@@@@@@@@@@@@@@@@    %@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@   
   @@@@@@@@@@@*    .@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@      @@@@@@@@@@@@   
   @@@@@@@@@@@      @@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@      @@@@@@@@@@@    
  @@@@@@@@@@@&     ,@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@       @@@@@@@@@@@    
  @@@@@@@@@@@@    /@@@@@@@@@@@@@@@@@@/ @@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@     
  @@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@      
  (@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@       
   @@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@        
    @@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@          
      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@@@@            
         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              
             (@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
                                      @@@@@@@@@@@@@@@@@@@@@                     
                                            @@@@@@@@@@@                #@@@@@,  
                                            @@@@@@@@@@@          @@@@@@@@@@@@@@@
                          @@@@@@@@@@.       @@@@@@@@@@@       @@@@@@@@@@@@@@@@, 
                        @@@@@@@@@@@@@@@@    @@@@@@@@@@@    &@@@@@@@@@@@         
                        &@@@@@@@@@@@@@@@@@# @@@@@@@@@@@   @@@@@@@@@@@           
                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*@@@@@@@@@@@@            
                          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              
                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               
                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                
                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
                               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&                 
                                 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  
                                   @@@@@@@@@@@@@@@@@@@@@@@@@@                   
                                     @@@@@@@@@@@@@@@@@@@@@@@                    
                                       @@@@@@@@@@@@@@@@@@@@(                    
                                         @@@@@@@@@@@@@@@@@&                     
                                           @@@@@@@@@@@@@@(                      
                                             @@@@@@@@@@@                        
                                              .@@@@@#                           
*/
```

Requirements:
=============
You need a machine with at least 32GB of RAM render the Solidity images.

Dependencies:
=============
1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Install [Visual Studio Code](https://code.visualstudio.com/)
3. Install [.NET 7.0](https://dotnet.microsoft.com/en-us/download/dotnet/7.0)

Rendering:
=========

1. After cloning the repository, ensure you have also cloned dependencies:
`git submodule update --init --recursive`

2. Follow the steps in `./solidity/README.md` to set up the mochi rendering node and deploy the contracts
3. Follow the steps in `./CityLights.Renderer/README.md` to set up the rendering service to create your images
4. Render and enjoy!

Font Attribution:
================

CityLights uses [Noto Sans JP](https://fonts.google.com/noto/specimen/Noto+Sans+JP/about), 
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).

CityLights uses [Nanum Gothing Coding](https://fonts.google.com/specimen/Nanum+Gothic+Coding/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).

CityLights uses [Sawarabi Gothic](https://fonts.google.com/specimen/Sawarabi+Gothic/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).
