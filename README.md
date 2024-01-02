


# Simple-Lumberjack 

Simple-Lumberjack script for QBCore Framework

Any problems contact me via discord denni_al

# Installation

**Add to qb-shops/config.lua**

*Add into Config.Products*
```
    ["lumbersupplies"] = {
        [1] = {
            name = 'battleaxe',
            price = 150,
            amount = 10,
            info = {},
            type = 'item',
            slot = 1,
        },
        [2] = {
            name = 'cutter',
            price = 500,
            amount = 1,
            info = {},
            type = 'item',
            slot = 2,
        },  
    },
```
*Add into Config.Locations*
```
    ["lumbersupplies"] = {
        ["label"] = "Lumber Supplies",
        ["coords"] = vector4(-841.4646, 5400.9839, 34.6152, 299.0667),-- Changethis to change the loco of shop
        ["ped"] = 'a_m_y_smartcaspat_01',
        ["scenario"] = "WORLD_HUMAN_STAND_MOBILE",
        ["radius"] = 1.5,
        ["targetIcon"] = "fas fa-shopping-basket",
        ["targetLabel"] = "Open Shop",
        ["products"] = Config.Products["lumbersupplies"],
        ["showblip"] = true,---True on to show blips
        ["blipsprite"] = 237,--change if you want
        ["blipscale"] = 0.6,
        ["blipcolor"] = 21 
    },
```

**Add to qb-core/shared.lua**

*Add into QBShared.Items*
```
	["battleaxe"]						= {["name"] = "battleaxe",       		    		["label"] = "Battle AXE",	 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "weapon_battleaxe.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Cut the Trees"},
	["cutter"]						= {["name"] = "cutter",       		    		["label"] = "Wood Cutter",	 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "cutter.png", 				["unique"] = true, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Cut the tommer!"},
    	["tommer"]						= {["name"] = "tommer",       		    		["label"] = "Tommer",	 			["weight"] = 2000, 		["type"] = "item", 		["image"] = "tommer.png", 			["unique"] = false, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "procces this!"},
	["planke"]						= {["name"] = "planke",       		    		["label"] = "Planke",	 				["weight"] = 3000, 		["type"] = "item", 		["image"] = "planke.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Sell it!!"},

```
 
 **Add Images into qb-inventory/html/images**
 
 

 
 
 **Dependencies**
 
 *By Default you should have these*
 
 qb-core: https://github.com/qbcore-framework/qb-core
 
 qb-inventory: https://github.com/qbcore-framework/qb-inventory
 
 qb-target: https://github.com/qbcore-framework/qb-target
 
 Progressbar: https://github.com/qbcore-framework/progressbar
 
 PolyZone: https://github.com/qbcore-framework/PolyZone
 
 
"# Simple-Lumberjack" 
