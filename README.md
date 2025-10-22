# README

# TO DO

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