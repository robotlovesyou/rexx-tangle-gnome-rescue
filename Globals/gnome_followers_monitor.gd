class_name GnomeFollowersMonitor
extends Node

var _followers_dict: Dictionary[int, int] = {}
var _followers_index: Array[Gnome]

func _ready() -> void:
	pass
	# EventsManager.player_on_moving_platform.connect(handle_player_on_moving_platform)
	# EventsManager.player_off_moving_platform.connect(handle_player_off_moving_platform)

func reset() -> void:
	_followers_dict.clear()
	_followers_index.clear()

func add(gnome: Gnome) -> int:
	assert(not _followers_dict.has(gnome.get_instance_id()), "Gnome with instance id %d already in followers index" % gnome.get_instance_id())
	var offset = _followers_index.size()
	_followers_dict[gnome.get_instance_id()] = offset
	_followers_index.append(gnome)
	return offset

func remove(gnome: Gnome) -> void:
	assert(_followers_dict.has(gnome.get_instance_id()), "Gnome with instance id %d is not a follower" % gnome.get_instance_id())
	var offset = _followers_dict[gnome.get_instance_id()]
	_followers_dict.erase(gnome.get_instance_id())
	_followers_index.remove_at(offset)
	for i in range(offset, _followers_index.size()):
		_followers_dict[_followers_index[i].get_instance_id()] = i
		# todo: gnomes should handle changes in their follower index and react accordingly. 
		# _followers_index[i].has_new_follow_index(i)

# func handle_player_on_moving_platform() -> void:
# 	for follower in _followers_index:
# 		# deferred call so that this state is not being updated as it iterates over the list
# 		follower.player_on_moving_platform.call_deferred()

# func handle_player_off_moving_platform() -> void:
# 	for follower in _followers_index:
# 		# deferred call so that this state is not being updated as it iterates over the list
# 		follower.player_off_moving_platform.call_deferred()
