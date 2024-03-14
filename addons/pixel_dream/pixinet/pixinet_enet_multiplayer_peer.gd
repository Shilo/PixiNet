class_name PixiNetENetMultiplayerPeer extends ENetMultiplayerPeer

const CLASS_NAME = "PixiNetENetMultiplayerPeer"

var connecting: bool:
	get: return get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING

var connected: bool:
	get: return get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED

var disconnected: bool:
	get: return get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED

static func start_server(port: int = PixiNet.DEFAULT_PORT, max_clients: int = 32, max_channels: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0) -> Dictionary:
	var peer := PixiNetENetMultiplayerPeer.new()
	var error := peer.create_server(port, max_clients, max_channels, in_bandwidth, out_bandwidth)
	
	if error:
		PixiNet.on_start_failed.emit(error)
	
	if PixiNet.log_level > PixiNet.LogLevel.NONE:
		var log_info :=  "Port = %s" % port
		if error:
			PixiNet.log_error("Server failed to start. %s. Error = %s." % [log_info, error], CLASS_NAME)
		else:
			PixiNet.log("Server started. %s." % log_info, CLASS_NAME)
	
	return {"peer": peer, "error": error}

static func start_client(address: String = PixiNet.DEFAULT_ADDRESS, port: int = PixiNet.DEFAULT_PORT, channel_count: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0, local_port: int = 0) -> Dictionary:
	var peer := PixiNetENetMultiplayerPeer.new()
	var error := peer.create_client(address, port, channel_count, in_bandwidth, out_bandwidth, local_port)
	
	if error:
		PixiNet.on_start_failed.emit(error)
	
	if PixiNet.log_level > PixiNet.LogLevel.NONE:
		var log_info :=  "Address = %s:%s" % [address, port]
		if error:
			PixiNet.log_error("Client failed to start. %s. Error = %s." % [log_info, error], CLASS_NAME)
		else:
			PixiNet.log("Client started. %s." % log_info, CLASS_NAME)
	
	return {"peer": peer, "error": error}

func stop() -> void:
	if PixiNet.log_level > PixiNet.LogLevel.NONE && get_connection_status() != CONNECTION_DISCONNECTED:
		PixiNet.log.call_deferred("%s stopped." % ("Server" if PixiNet.is_server else "Client"), CLASS_NAME)
	
	close()
