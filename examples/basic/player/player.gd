extends CharacterBody2D

@export var speed = 300.0

func _enter_tree() -> void:
	auth_set_position()

#func _physics_process(_delta: float) -> void:
	#velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
	#move_and_slide()

func auth_set_position():
	if !is_multiplayer_authority(): return
	
	var window_size = get_viewport_rect().size
	var sprite_half_size = (%Sprite as Sprite2D).texture.get_size() / 2
	
	position = Vector2i(
		randi_range(sprite_half_size.x, window_size.x - sprite_half_size.x),
		randi_range(sprite_half_size.y, window_size.y - sprite_half_size.y)
	)
