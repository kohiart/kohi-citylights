# CityLights by eepmon
# Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

Website: https://eepmon.com/
Twitter: https://twitter.com/eepmon
Gallery: https://kohi.art/collections/citylights

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

Rendering Steps
===============

1. Ensure you have deployed the Solidity contracts to mochi, by following this README:
`./solidity/README.md`

2. Run the project, passing in the CityLights Token ID you wish to render:
`dotnet run {TOKEN_ID}`

The rendering service will:

- Create a C# rendering of the Token ID (this can take up to 30 seconds to complete)
- Create a Solidity rendering of the Token ID (this can take 25 minutes to an hour to complete)
- Compare the two renderings to ensure they match pixel-for-pixel.

Your images will appear in the `./renders` folder.

Font Attribution:
================

CityLights uses [Noto Sans JP](https://fonts.google.com/noto/specimen/Noto+Sans+JP/about), 
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)

CityLights uses [Nanum Gothing Coding](https://fonts.google.com/specimen/Nanum+Gothic+Coding/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)

CityLights uses [Sawarabi Gothic](https://fonts.google.com/specimen/Sawarabi+Gothic/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)