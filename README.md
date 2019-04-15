# Godot 3.1 Advanced Save System

An advanced save system prototype for Godot 3.1.
Based on this short guide: https://docs.godotengine.org/en/3.0/tutorials/io/saving_games.html.

![screenshot]

This save system can be used in rpg games where the player moves from level to level and the game has to keep track of all the changes to those levels.

The demo constist of three levels: green < red > blue. You move through them by stepping on the yellow arrows. White circles are rigid bodies, their properties will be saved either when you save to a slot (buttons at the top) OR automatically when moving to another level. Red blocks are enemies, they will get permanently deleted from the scene once collided with. You can also move objects from one level to another, but it's not shown in the demo.

## How the system works:

* **Entering a level**.

* **If the map has been entered before**:
  - Load the original map.
  - Let the player change stuff.
  - Save when exiting or saving to a slot.

* **Else**:
  - Load the original map.
  - Delete all dynamic nodes, add nodes that are in the save data and change their properties.

**current_data** - objects and their variables in current world state. This data is "captured" when saving to a slot. When loading the game, the data from a slot hops in in place of current_data.

## What it can do:
  - Save predefined variables as well as custom ones (defined either in main file or nodes)
  - Teleport objects to different levels
  - Dynamicaly update the levels based on current_data and the save the data to a file

## Known bugs:
  - Loading from a file doesn't work (something wrong with json parsing, I think).
  - Weird behavior when saving added objects - only the first one gets updated.
  
[screenshot]: https://i.imgur.com/DM68NuH.png

