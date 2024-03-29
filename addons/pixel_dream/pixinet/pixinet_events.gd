class_name PixiNetEvents extends Node
var CLASS_NAME: String = "PixiNetEvents"

signal on_start_failed(error: Error, was_server: bool)

signal on_start(id: int)
signal on_stop(id: int)
signal on_peer_start(id: int)
signal on_peer_stop(id: int)
signal on_peer_authenticating(id: int)
signal on_peer_authentication_failed(id: int)

signal on_server_start(id: int)
signal on_server_stop(id: int)
signal on_server_peer_start(id: int)
signal on_server_peer_stop(id: int)
signal on_server_peer_authenticating(id: int)
signal on_server_peer_authentication_failed(id: int)

signal on_client_start(id: int)
signal on_client_stop(id: int)
signal on_client_peer_start(id: int)
signal on_client_peer_stop(id: int)
signal on_client_peer_authenticating(id: int)
signal on_client_peer_authentication_failed(id: int)

var _multiplayer: MultiplayerAPI
var _unique_id: int

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

func _ready():
	if _processing:
		update()
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
			_emit_on_start()
		else:
			_emit_on_stop()
		_was_server_connected = server_connected

func add_events(multiplayer_api: SceneMultiplayer) -> void:
	if !multiplayer_api: return
	
	multiplayer_api.connection_failed.connect(_on_connection_failed)
	multiplayer_api.connected_to_server.connect(_on_connected_to_server)
	multiplayer_api.server_disconnected.connect(_on_server_disconnect)
	multiplayer_api.peer_connected.connect(_on_peer_connected)
	multiplayer_api.peer_disconnected.connect(_on_peer_disconnected)
	
	if multiplayer_api is SceneMultiplayer:
		var scene_multiplayer: SceneMultiplayer = multiplayer_api
		scene_multiplayer.peer_authenticating.connect(_on_peer_authenticating)
		scene_multiplayer.peer_authentication_failed.connect(_on_peer_authentication_failed)

func remove_events(multiplayer_api: MultiplayerAPI) -> void:
	if !multiplayer_api: return
	
	multiplayer_api.connection_failed.disconnect(_on_connection_failed)
	multiplayer_api.connected_to_server.disconnect(_on_connected_to_server)
	multiplayer_api.server_disconnected.disconnect(_on_server_disconnect)
	multiplayer_api.peer_connected.disconnect(_on_peer_connected)
	multiplayer_api.peer_disconnected.disconnect(_on_peer_disconnected)
	
	if multiplayer_api is SceneMultiplayer:
		var scene_multiplayer: SceneMultiplayer = multiplayer_api
		scene_multiplayer.peer_authenticating.disconnect(_on_peer_authenticating)
		scene_multiplayer.peer_authentication_failed.disconnect(_on_peer_authentication_failed)

func _on_connection_failed() -> void:
	on_start_failed.emit(ERR_CONNECTION_ERROR, false)

func _on_connected_to_server() -> void:
	_emit_on_start()

func _on_server_disconnect() -> void:
	_emit_on_stop()

func _on_peer_connected(peer_id: int) -> void:
	on_peer_start.emit(peer_id)
	(on_server_peer_start if PixiNet.is_server_unique_id else on_client_peer_start).emit(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	on_peer_stop.emit(peer_id)
	(on_server_peer_stop if PixiNet.is_server_unique_id else on_client_peer_stop).emit(peer_id)

func _on_peer_authenticating(peer_id: int) -> void:
	on_peer_authenticating.emit(peer_id)
	(on_server_peer_authenticating if PixiNet.is_server_unique_id else on_client_peer_authenticating).emit(peer_id)

func _on_peer_authentication_failed(peer_id: int) -> void:
	on_peer_authentication_failed.emit(peer_id)
	(on_server_peer_authentication_failed if PixiNet.is_server_unique_id else on_client_peer_authentication_failed).emit(peer_id)

func _emit_on_start() -> void:
	if _unique_id != 0: return # Start event has already been emitted
	
	_unique_id = multiplayer.get_unique_id()
	var is_server := _is_server_unique_id(_unique_id)
	
	if PixiNet.log_level > PixiNet.LogLevel.NONE:
		PixiNet.log("%s started." % _peer_type_name(is_server), CLASS_NAME)
	
	on_start.emit(_unique_id)
	(on_server_start if is_server else on_client_start).emit(_unique_id)

func _emit_on_stop() -> void:
	if _unique_id == 0: return # Stop event has already been emitted
	
	var is_server := _is_server_unique_id(_unique_id)
	
	if PixiNet.log_level > PixiNet.LogLevel.NONE:
		PixiNet.log("%s stopped." % _peer_type_name(is_server), CLASS_NAME)
	
	on_stop.emit(_unique_id)
	(on_server_stop if is_server else on_client_stop).emit(_unique_id)
	
	_unique_id = 0

func _is_server_unique_id(id: int) -> bool:
	return id == MultiplayerPeer.TARGET_PEER_SERVER

func _peer_type_name(is_server: bool) -> String:
	return "Server" if is_server else "Client"
