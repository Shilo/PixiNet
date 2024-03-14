class_name PixiNet

const CLASS_NAME = "PixiNet"
const DEFAULT_ADDRESS: String = "localhost"
const DEFAULT_PORT: int = 16924

enum LogLevel {
	NONE,
	ERROR,
	WARN,
	INFO
}

static var on_start_failed: Signal:
	get: return events.on_start_failed

static var on_start: Signal:
	get: return events.on_start

static var on_stop: Signal:
	get: return events.on_stop

static var on_peer_start: Signal:
	get: return events.on_peer_start

static var on_peer_stop: Signal:
	get: return events.on_peer_stop

static var log_level: LogLevel = LogLevel.NONE

static var multiplayer: MultiplayerAPI:
	get: return tree.get_multiplayer()
	set(value):
		tree.set_multiplayer(value)

static var tree: SceneTree:
	get: return Engine.get_main_loop()

static var connecting: bool:
	get:
		var peer := multiplayer.multiplayer_peer
		if !is_online_peer(peer): return false
		return peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING

static var connected: bool:
	get:
		var peer := multiplayer.multiplayer_peer
		if !is_online_peer(peer): return false
		return peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED

static var disconnected: bool:
	get:
		var peer := multiplayer.multiplayer_peer
		if !is_online_peer(peer): return true
		return peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED

static var is_server: bool:
	get:
		return connected && multiplayer.is_server()

static var is_client: bool:
	get:
		return connected && !multiplayer.is_server()

static var _events: PixiNetEvents
static var events: PixiNetEvents:
	get:
		if !_events:
			_events = PixiNetEvents.new()
			_events.name = "PixiNetEvents"
			tree.root.add_child.call_deferred(_events)
		return _events

static var event_processing: bool:
	get: return _events && _events.processing
	set(value):
		events.processing = value

static func start_server(port: int = DEFAULT_PORT, max_clients: int = 32, max_channels: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0) -> Error:
	var result: Dictionary = PixiNetENetMultiplayerPeer.start_server(port, max_clients, max_channels, in_bandwidth, out_bandwidth)
	multiplayer.multiplayer_peer = result.peer if !result.error else OfflineMultiplayerPeer.new()
	return result.error

static func start_client(address: String = DEFAULT_ADDRESS, port: int = DEFAULT_PORT, channel_count: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0, local_port: int = 0) -> Error:
	var result: Dictionary = PixiNetENetMultiplayerPeer.start_client(address, port, channel_count, in_bandwidth, out_bandwidth, local_port)
	multiplayer.multiplayer_peer = result.peer if !result.error else OfflineMultiplayerPeer.new()
	return result.error

static func stop():
	var peer = multiplayer.multiplayer_peer
	
	if peer is PixiNetENetMultiplayerPeer:
		peer.stop()
		return
	
	peer.close()

static func is_online_peer(peer: MultiplayerPeer) -> bool:
	return peer && !(peer is OfflineMultiplayerPeer)
	
static func log(message: String, subject: String = CLASS_NAME, level: LogLevel = LogLevel.INFO, force: bool = false) -> void:
	if !force && level > log_level: return
	
	if !subject.is_empty():
		message = "[%s] %s" % [subject, message]
	
	if connected:
		var id := multiplayer.get_unique_id()
		var socket_name = "Server" if id == MultiplayerPeer.TARGET_PEER_SERVER else "Client"
		message = "[%s %s] %s" % [socket_name, multiplayer.get_unique_id(), message]
	
	match level:
		LogLevel.INFO:
			print(message)
		LogLevel.WARN:
			push_warning(message)
		LogLevel.ERROR:
			push_error(message)

static func log_info(message: String, subject: String = CLASS_NAME, force: bool = false) -> void:
	PixiNet.log(message, subject, LogLevel.INFO, force)

static func log_warn(message: String, subject: String = CLASS_NAME, force: bool = false) -> void:
	PixiNet.log(message, subject, LogLevel.WARN, force)

static func log_error(message: String, subject: String = CLASS_NAME, force: bool = false) -> void:
	PixiNet.log(message, subject, LogLevel.ERROR, force)
