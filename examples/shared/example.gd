class_name Example extends Node

@export var address: String = PixiNet.DEFAULT_ADDRESS
@export var port: int = PixiNet.DEFAULT_PORT
@export var player_scene: PackedScene
@export var reposition_window: bool = true

var players: Dictionary = {}

func _ready() -> void:
	if reposition_window:
		position_window(multiplayer.is_server())

func add_player(id: int) -> void:
	var player := player_scene.instantiate()
	player.name += " #%d" % id
	add_child(player)
	
	print("add:", id)
	players[id] = player

func remove_player(id: int) -> void:
	var player = players[id]
	if !player: return
	
	print("remove:", id)
	players.erase(id)
	player.queue_free()

func position_window(hosting: bool) -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = DisplayServer.window_get_size_with_decorations(get_window().get_window_id())
	var offset_direction: int = -1 if hosting else 1
	
	var position: Vector2i = (screen_size - window_size) / 2.0
	position.x += int(window_size.x * offset_direction / 2.0)
	get_window().position = position
