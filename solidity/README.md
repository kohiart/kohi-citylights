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

Deploy Steps 
============

1. Install dependencies:

`npm install`

2. Add a symlink to the Kohi contracts in this repository, or copy them into `./solidity/contracts/Kohi`:

`mklink /D "[PATH_TO_THIS_REPO]\solidity\contracts\Kohi" "[PATH_TO_THIS_REPO]\lib\kohi-composer\solidity\contracts"`

3. Start mochi container:

`docker compose -f "docker\docker-compose.yml" up -d --build`

4. Deploy to mochi:

`npx hardhat --network mochi deploy`

At the end of this process, the manifest file is copied to `./CityLights.Renderer`, where it is used in rendering.

Follow the steps in that project's `README.md` to continue.

Font Attribution:
================

CityLights uses [Noto Sans JP](https://fonts.google.com/noto/specimen/Noto+Sans+JP/about), 
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).

CityLights uses [Nanum Gothing Coding](https://fonts.google.com/specimen/Nanum+Gothic+Coding/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).

CityLights uses [Sawarabi Gothic](https://fonts.google.com/specimen/Sawarabi+Gothic/about)
licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).
