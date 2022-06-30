# Assistant
This script will give players the ability to obtain heirlooms, glyphs, gems, containers, utilities like name change and faction change, increase their profession skills to their max value.

The npc that offer these services can be spawned by using **.npc add 9000000**. There are also example spawn points that can be used by uncommenting the section of the sql file related to spawn points. Those spawn points are Stormwind City, Ironforge, Darnassus, The Exodar, Orgrimmar, Thunder Bluff, Undercity, Silvermoon City and Dalaran.

All the features are enabled, or disabled, by modifying the script - allowing a user to only use the features they want.

**Note:** You need to import *assistant.sql* to the world database.

# Requirements
This is a script that requires [Eluna](https://github.com/azerothcore/mod-eluna) to be installed for [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk).

The file `Assistant.lua` has to be placed in the `lua_scripts` folder found in the same location as the worldserver executable.

You have to restart the server after starting it when the script is first installed if you use glyphs or gems. This is because the script will set the sell price of those items to 0 and the server won't update those values until the server is restarted.
