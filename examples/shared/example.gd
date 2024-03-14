class_name Example extends Node

@export var address: String = PixiNet.DEFAULT_ADDRESS
@export var port: int = PixiNet.DEFAULT_PORT
@export var player_scene: PackedScene
@export var reposition_window: bool = true

var players: Dictionary = {}

func _ready() -> void:
	PixiNet.on_start.connect(_on_start)
	PixiNet.on_stop.connect(_on_stop)
	PixiNet.on_peer_start.connect(_on_peer_start)
	PixiNet.on_peer_stop.connect(_on_peer_stop)
	
	if reposition_window:
		position_window()

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

func remove_players() -> void:
	for id in players:
		players[id].queue_free()
	players.clear()

func position_window() -> void:
	await get_tree().process_frame
	
	var hosting := multiplayer.is_server()
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = DisplayServer.window_get_size_with_decorations(get_window().get_window_id())
	var offset_direction: int = -1 if hosting else 1
	
	var position: Vector2i = (screen_size - window_size) / 2.0
	position.x += int(window_size.x * offset_direction / 2.0)
	get_window().position = position

func _on_start(_id: int) -> void:
	pass

func _on_stop() -> void:
	pass

func _on_peer_start(_id: int) -> void:
	pass

func _on_peer_stop(_id: int) -> void:
	pass
