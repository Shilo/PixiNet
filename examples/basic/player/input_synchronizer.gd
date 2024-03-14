class_name InputSynchronizer extends MultiplayerSynchronizer

var movement: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_physics_process(is_multiplayer_authority())

func _physics_process(_delta: float) -> void:
	movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
