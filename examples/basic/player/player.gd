extends CharacterBody2D

@export var speed = 300.0

var id: int:
	set(value):
		id = value
		input.set_multiplayer_authority(id)

var input: InputSynchronizer:
	get: return %InputSynchronizer

func _ready() -> void:
	auth_set_position()
	if input.is_multiplayer_authority():
		%Sprite.modulate = Color.GREEN

func _physics_process(_delta: float) -> void:
	velocity = input.movement * speed
	move_and_slide()

func auth_set_position():
	if !is_multiplayer_authority(): return
	
	var window_size = get_viewport_rect().size
	var sprite_half_size = %Sprite.texture.get_size() / 2
	
	position = Vector2i(
		randi_range(sprite_half_size.x, window_size.x - sprite_half_size.x),
		randi_range(sprite_half_size.y, window_size.y - sprite_half_size.y)
	)
