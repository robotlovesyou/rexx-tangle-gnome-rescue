extends BaseLevel

@export var training_dialogs_layer: TrainingDialogsLayer
@export var enemy_training_dialog: TrainingDialog
@export var gnome_training_dialog: TrainingDialog
@export var exit_training_dialog: TrainingDialog
@export var gnome_count_door: Door
@export var timer_door: Door



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hud.hide_gnome_count()
	hud.hide_timer()

func _physics_process(delta: float) -> void:
	super(delta)


func _on_training_dialog_requested(text: String) -> void:
	training_dialogs_layer.open(text)

func _on_training_dialog_freed(text: String) -> void:
	training_dialogs_layer.close(text)

func _on_training_enemy_died() -> void:
	enemy_training_dialog.active = false

func on_gnome_count_dialog_requested(text: String) -> void:
	hud.show_gnome_count()
	hud.hilight_gnome_count()
	_on_training_dialog_requested(text)

func _on_hud_hilight_gnome_count_done() -> void:
	gnome_count_door.open_door()


func _on_timer_training_dialog_training_dialog_requested(text: String) -> void:
	gnome_count_door.close_door()
	hud.show_timer()
	hud.hilight_timer()
	_on_training_dialog_requested(text)


func _on_hud_hilight_timer_done() -> void:
	timer_door.open_door()

func _on_gnome_dialog_freed(text: String) -> void:
	_on_training_dialog_freed(text)
	gnome_training_dialog.active = false

func _on_player_entered_exit() -> void:
	super()
	_on_training_dialog_requested(exit_training_dialog.text)


func _on_player_exited_exit() -> void:
	super()
	_on_training_dialog_freed(exit_training_dialog.text)


	
