# README

# TO DO

## Next Up
* All the lights should react to beat2 or beat1. Use different approaches for each light (energy or area modulation. Color modulation etc)
* Remove the collision mask and add an area2d to the drop traps, so they don't push the player/gnomes through the floor
* Add wormies and other bugs to break up large platform blocks even more.
* Better flown by birbs animation. Try creating a kinematic rope.


## Backlog
* Gnome appear shaders should be duplicated per gnome so they do not show on all gnomes when one gnome appears
* Add a wheeeeee sound effect for rexx when flown by birbs (not sure about this)
* Leaves with player visibility shader
* Move the camera out of the player to fix jumps and glitches on death and scene transitions
* Add spawning indicators to the minimap to show gnomes respawning.
* Use instance ids to re-use minimap children rather than recrating each physics tick
* Improve minimap appearance relative to rest of HUD
* Add a fade between the menu screens (Partially done)
* Decide how the game deals with difficulty, levels and level navigation, scores, save games etc
* Add continue/new game buttons to the title screen

## Done
* ~~Whenever either the player or one of their gnomes dies, the death, and cause of death, should chain along all the gnomes and the player.~~
* ~~BUG: collecting a gnome whilst webbed causes an index out of bounds error~~
* ~~Lay out level~~
* ~~Add the surface leaves tilemap layers so large platform blocks can be broken up.~~
* ~~Try using global illumination instead of point lights on the layer for things like particles~~
* ~~optimise lighting for flame traps by adding some lighting toggles, and creating some pre-built lights for 2/3/4/5/6 traps using a single point light~~
* ~~Draw Big Old Trees~~
* ~~Misty Background~~
* ~~Flame Traps~~
* ~~Do a little layout and experiment with 2D lighting~~
* ~~Spider Web Mechanic~~
* ~~Add a seed pour sound to the birb feeder~~
* ~~Add a birb flock sound effect~~
* ~~Add a button click sound to the birb feeder~~
* ~~Create unique music for the training level. Just a fairly short loop should do.~~
* ~~Add the next environment (starting with the music)~~
* ~~Refactor the gnomes to ignore terrain~~
* ~~Refactor the gnomes to ignore platforms~~
* ~~If possible use wall rays to calculate wall normal~~
* ~~Refactor the gnomes to allow for respawning~~
* ~~Add a minimap~~
* ~~Level intro text should all show on first press of space and only exit on second~~
* ~~Better beat data for the examination level~~
* ~~stop the gnome training dialog firing after owned gnome is rescued
* ~~Use Jules' gnome recordings.~~
* ~~Gnome death sfx~~
* ~~Gnome rescue sfx~~
* ~~Ensure new gnomes have appear/disappear and death animations~~
* ~~Make the spike trap above the third gnome less of a shit~~
* ~~Re-build tutorial using updated appearance~~
* ~~Add an extra gnome and update dialog texts~~
* ~~Fix the bug with the gnome chain getting further behind the player~~
* ~~Re build existing cutscene to use a bottom docked text dialog with a portrait and a next button~~
* ~~Add the Basement cutscene~~
* ~~Add an intro screen for the training level~~
* ~~Update the intro screen for the examination level to reflect the tutorial now existing.~~
* ~~Stop gnomes dying off screen long after player has died~~ (hopefully)
* ~~Re-release with all above items fixed and included~~

## General

* ~~Make Game Over actually work~~

* ~~Switch to using file scenes instead of packed scenes~~
* ~~Gnomes need better abandonment detection. ~~
* ~~Gnomes may need better idle behaviour.~~
* ~~Idling gnomes should switch to wander after a time. ~~
* ~~Add wall terrains OR disallow jumping through the floor of non moving platforms?~~
* ~~Add an exit for the gnomes~~
* ~~Add hazards~~
* ~~Add enemies and enemy interactions~~
* ~~Add gnome panic state, triggered by falling off or missing a moving platform~~
* ~~Add a countdown timer~~
* ~~Add level completion / score~~

# Possible better way to detect being abandoned
If the gnome is in some kind of idle state (stray, platform_idle etc) for > a set time AND has greater than LIMIT y difference
So basically, if the gnome is on a different bit of ground/platform and waiting for more than a second or so...
