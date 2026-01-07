# README

# TO DO

# Week 1 2026
* Gnome Death
* Move as much code as possible out of level manager global and into base_level class
* Make Game Over actually work

## General

* Add a fade between the menu screens
* Switch to using file scenes instead of packed scenes
* Gnomes need better abandonment detection. 
* Gnomes may need better idle behaviour.
* Idling gnomes should switch to wander after a time. 
* Add wall terrains OR disallow jumping through the floor of non moving platforms?
* Add an exit for the gnomes
* Add hazards
* Add enemies and enemy interactions
* Add gnome panic state, triggered by falling off or missing a moving platform
* Add a countdown timer
* Add level completion / score

## Office Intro Scene

* Add user interaction to acknowledge text
* Split text across > 1 dialog

## Training Level

* ~~Add walking sound to player~~
* ~~Add jump sound to player~~
* ~~Add double jump sound to player~~
* ~~Add wall jump sound to player~~
* ~~Add death sound to player (broken crockery?)~~
* ~~Add exit sound effect for player~~
* ~~Add skid sound to player~~ (could do with some work)
* ~~Add skid particles to player~~
* ~~Add death sound for path follower enemy~~
* ~~Add proper exit handling (don't just free the player)~~
* Add rescue sound for gnome
* Add exit sound for gnome
* ~~Create a base class for the level~~
* Move the level manager code into the base class (not sure about this)
* Make signal handling consistent (events bus vs whatever else) (also not sure about this)
* Tidy code for consistency (how to access child nodes. how to access config, etc)
* ~~Add hazard blocks~~
* ~~Add enemies~~
* ~~Add jumping on enemies~~
* ~~Add vertical platforms~~
* ~~Add horizontal platforms~~
* ~~Add Gnomes~~
* ~~Add Player Death~~
* ~~Add Gnome Rescue: In progress~~
* ~~Add the timer and rescue counter~~


* ~~Add double jumps~~
* ~~Add wall jumps~~
* ~~Add wall slides~~
* ~~Add gnomes~~
* ~~Gnomes - Handle Wait~~
* ~~Gnomes - Handle Collection~~
* ~~Gnomes - Handle WALKING~~
* ~~Add moving platforms: Done but gnomes need to correctly move while player is on them~~
* ~~Gnomes - Handle approaching platforms~~
* ~~Gnomes - Handle JUMPING: partially done but needs animation~~
* ~~Gnomes - Handle STRAYING when the player is IDLE: partially done but needs to switch to wander state after a given time~~
* ~~new GnomeFollowState can sometimes get stuck and jump. Need to detect when stuck and react appropriately~~
* ~~Straying gnomes need to eventually enter wander state~~
* ~~Straying gnomes need to react to gravity in the event that they walk off a ledge.~~
* ~~Handle going into wander state if the player gets too far away after becoming stuck~~
* ~~Gnomes - Handle STRAYING on platforms when the player is IDLE~~
* ~~Alter number of follow lerp frames depending on gnome index~~
* ~~Also lerp toward eventual offset to prevent giant leaps back in history~~
* ~~When stuck, try adding a little hop _before_ starting the follow lerp~~

# Possible better way to detect being abandoned
If the gnome is in some kind of idle state (stray, platform_idle etc) for > a set time AND has greater than LIMIT y difference
So basically, if the gnome is on a different bit of ground/platform and waiting for more than a second or so...