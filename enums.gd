class_name Enums
extends Object

enum Action {
	DOUBLE_JUMPED,
	DOUBLE_JUMPING,
	DYING, 
	FALLING, 
	IDLING, 
	JUMPING, 
	NONE, 
	PLATFORM_IDLING,
	PLATFORM_WALKING,
	WALKING, 
	WALL_JUMPING,
	WALL_SLIDING,
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
	BECAME_FREE,
	BECAME_GROUNDED,
	BECAME_ORPHANED,
	BECAME_STUCK, 
	BEGAN_APPROACHING_PLATFORM,
	COLLECTION_DONE,
	DIED, 
	FALLING_FATALLY,
	HIT_SAFE_SPOT,
	LANDED_ON_PLATFORM,
	LERP_FOLLOW_DONE,
	PLAYER_BECAME_IDLE,
	PLAYER_COLLECTED,
	PLAYER_STOPPED_IDLING
}
static func gnome_event_name(event: GnomeEvent) -> String: return GnomeEvent.find_key(int(event))

enum DeathReason {
	PIERCED,
	BURNED,
	POISONED
}

static func death_reason_name(reason: DeathReason) -> String: return DeathReason.find_key((int(reason)))
