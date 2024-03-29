class_name Example extends Node

@export var address: String = PixiNet.DEFAULT_ADDRESS
@export var port: int = PixiNet.DEFAULT_PORT
@export var player_scene: PackedScene
@export var reposition_window: bool = true

var players: Dictionary = {}

func _ready() -> void:
	PixiNet.on_peer_authenticating.connect(_on_peer_authenticating)
	PixiNet.on_peer_authentication_failed.connect(_on_peer_authentication_failed)
	PixiNet.on_start_failed.connect(_on_start_failed)
	PixiNet.on_start.connect(_on_start)
	PixiNet.on_stop.connect(_on_stop)
	PixiNet.on_server_start.connect(_on_server_start)
	PixiNet.on_server_peer_start.connect(_on_server_peer_start)
	PixiNet.on_server_peer_stop.connect(_on_server_peer_stop)
	
	PixiNet.log_level = PixiNet.LogLevel.WARN
	
	if reposition_window:
		position_window()

func add_player(id: int) -> void:
	var player := player_scene.instantiate()
	player.name += " #%d" % id
	player.id = id
	add_child(player)
	
	players[id] = player

func remove_player(id: int) -> void:
	var player = players[id]
	if !player: return
	
	players.erase(id)
	player.queue_free()

func remove_players() -> void:
	for id in players:
		players[id].queue_free()
	players.clear()

func position_window() -> void:
	await get_tree().process_frame
	
	var hosting := PixiNet.is_server
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = DisplayServer.window_get_size_with_decorations(get_window().get_window_id())
	var offset_direction: int = -1 if hosting else 1
	
	var position: Vector2i = (screen_size - window_size) / 2.0
	position.x += int(window_size.x * offset_direction / 2.0)
	get_window().position = position

func _on_start_failed(error: Error, was_server: bool) -> void:
	PixiNet.log_error("%s failed to start. Error = %d." % [_peer_type_name(was_server), error], "", false)

func _on_start(id: int) -> void:
	add_debug_info(id)

func _on_server_start(id: int) -> void:
	PixiNet.log_info("Server started. ID = %d." % id, "", true)

func _on_server_peer_start(id: int) -> void:
	PixiNet.log_info("Peer started. ID = %d." % id, "", true)

func _on_server_peer_stop(id: int) -> void:
	PixiNet.log_info("Peer stopped. ID = %d." % id, "", true)

func _on_peer_authenticating(id: int) -> void:
	PixiNet.log_info("Peer authenticating. ID = %d." % id, "", true)

func _on_peer_authentication_failed(id: int) -> void:
	PixiNet.log_error("Peer authentication failed. ID = %d." % id, "", true)

func _peer_type_name(is_server: bool) -> String:
	return "Server" if is_server else "Client"

func _on_stop(_id: int) -> void:
	pass
	
func add_debug_info(id: int) -> void:
	get_window().title += " #%d" % id
	
	var peer_debug = Node.new()
	peer_debug.name += "Peer #%d" % id
	get_parent().add_child(peer_debug)
