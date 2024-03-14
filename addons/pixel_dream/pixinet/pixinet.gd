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

static func start_server(port: int = DEFAULT_PORT, max_clients: int = 32, max_channels: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0) -> Error:
	var result: Dictionary = PixiNetENetMultiplayerPeer.start_server(port, max_clients, max_channels, in_bandwidth, out_bandwidth)
	multiplayer.multiplayer_peer = result.peer if !result.error else OfflineMultiplayerPeer.new()
	return result.error

static func start_client(address: String = DEFAULT_ADDRESS, port: int = DEFAULT_PORT, channel_count: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0, local_port: int = 0) -> Error:
	pass
	var result: Dictionary = PixiNetENetMultiplayerPeer.start_client(address, port, channel_count, in_bandwidth, out_bandwidth, local_port)
	multiplayer.multiplayer_peer = result.peer if !result.error else OfflineMultiplayerPeer.new()
	return result.error

static func is_online_peer(peer: MultiplayerPeer) -> bool:
	return peer && !(peer is OfflineMultiplayerPeer)

static func log(message: String, subject: String = CLASS_NAME, level: LogLevel = LogLevel.INFO) -> void:
	if level > log_level: return
	
	if !subject.is_empty():
		message = "[%s] %s" % [subject, message]
	
	match level:
		LogLevel.INFO:
			print(message)
		LogLevel.WARN:
			push_warning(message)
		LogLevel.ERROR:
			push_error(message)

static func log_warn(message: String, subject: String = CLASS_NAME) -> void:
	PixiNet.log(message, subject, LogLevel.WARN)

static func log_error(message: String, subject: String = CLASS_NAME) -> void:
	PixiNet.log(message, subject, LogLevel.ERROR)
