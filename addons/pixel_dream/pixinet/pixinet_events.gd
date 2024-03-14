class_name PixiNetEvents extends Node

signal on_start_failed
signal on_start(id: int)
signal on_stop
signal on_peer_start(id: int)
signal on_peer_stop(id: int)

var _multiplayer: MultiplayerAPI

var _processing: bool = true
var processing: bool:
	get: return _processing
	set(value):
		_processing = value
		set_process(_processing)

var _was_server_connected: bool = false
var _server_connected: bool:
	get:
		return PixiNet.is_server && PixiNet.connected
		
func _init() -> void:
	update()

func _ready():
	set_process(_processing)

func _process(delta: float) -> void:
	update()

func update() -> void:
	if multiplayer != _multiplayer:
		remove_events(_multiplayer)
		add_events(multiplayer)
		_multiplayer = multiplayer
	
	var server_connected := _server_connected
	if server_connected != _was_server_connected:
		if server_connected:
			on_start.emit(multiplayer.get_unique_id())
		else:
			on_stop.emit()
		_was_server_connected = server_connected

func add_events(multiplayer_api: MultiplayerAPI) -> void:
	if !multiplayer_api: return
	
	multiplayer_api.connection_failed.connect(_on_connection_failed)
	multiplayer_api.connected_to_server.connect(_on_connected_to_server)
	multiplayer_api.server_disconnected.connect(_on_server_disconnect)
	multiplayer_api.peer_connected.connect(_on_peer_connected)
	multiplayer_api.peer_disconnected.connect(_on_peer_disconnected)

func remove_events(multiplayer_api: MultiplayerAPI) -> void:
	if !multiplayer_api: return
	
	multiplayer_api.connection_failed.disconnect(_on_connection_failed)
	multiplayer_api.connected_to_server.disconnect(_on_connected_to_server)
	multiplayer_api.server_disconnected.disconnect(_on_server_disconnect)
	multiplayer_api.peer_connected.disconnect(_on_peer_connected)
	multiplayer_api.peer_disconnected.disconnect(_on_peer_disconnected)

func _on_connection_failed() -> void:
	on_start_failed.emit()

func _on_connected_to_server() -> void:
	on_start.emit(multiplayer.get_unique_id())

func _on_server_disconnect() -> void:
	on_stop.emit()

func _on_peer_connected(peer_id: int) -> void:
	on_peer_start.emit(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	on_peer_stop.emit(peer_id)
