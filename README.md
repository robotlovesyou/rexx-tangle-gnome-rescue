# README

# TO DO

## Next Up
* ~~Refactor the gnomes to ignore terrain~~
* ~~If possible use wall rays to calculate wall normal~~
* Refactor the gnomes to ignore platforms
* Refactor the gnomes to allow for respawning
* Level intro text should all show on first press of space and only exit on second


## Backlog
* Add the next environment (blocked by all above)
* Add a fade between the menu screens (Partially done)
* Decide how the game deals with difficulty, levels and level navigation, scores, save games etc
* Add continue/new game buttons to the title screen

## Done
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
