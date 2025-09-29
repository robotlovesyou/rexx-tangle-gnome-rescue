class_name Enums
extends Object

enum Action {
	NONE, 
	IDLING, 
	FALLING, 
	WALKING, 
	JUMPING, 
	DOUBLE_JUMPING, 
	WALL_SLIDING_UP, 
	WALL_SLIDING_DOWN, 
	WALL_JUMPING
}
static func action_name(action: Action) -> String: return Action.find_key(int(action))

enum GnomeAction{
	GROUNDED, 
	AIRBORNE
}
static func gnome_action_name(action: GnomeAction) -> String: return GnomeAction.find_key(int(action))

enum GnomeEvent{
	BECAME_ABANDONED,
	BECAME_AIRBORNE, 
	BECAME_GROUNDED,
	BECAME_STUCK, 
	COLLECTION_DONE, 
	LERP_FOLLOW_DONE,
	PLAYER_BECAME_IDLE,
	PLAYER_COLLECTED,
	PLAYER_STOPPED_IDLING
}
static func gnome_event_name(event: GnomeEvent) -> String: return GnomeEvent.find_key(int(event))
