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
	
	if PixiNet.log_level > PixiNet.LogLevel.NONE:
		var log_info :=  "Port = %s" % port
		if error:
			PixiNet.log_error("Failed to start server. %s. Error = %s." % [log_info, error], CLASS_NAME)
		else:
			PixiNet.log("Started server. %s." % log_info, CLASS_NAME)
	
	return {"peer": peer, "error": error}

static func start_client(address: String = PixiNet.DEFAULT_ADDRESS, port: int = PixiNet.DEFAULT_PORT, channel_count: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0, local_port: int = 0) -> Dictionary:
	var peer := PixiNetENetMultiplayerPeer.new()
	var error := peer.create_client(address, port, channel_count, in_bandwidth, out_bandwidth, local_port)
	
	if PixiNet.log_level > PixiNet.LogLevel.NONE:
		var log_info :=  "Address = %s:%s" % [address, port]
		if error:
			PixiNet.log_error("Failed to start client. %s. Error = %s." % [log_info, error], CLASS_NAME)
		else:
			PixiNet.log("Started client. %s." % log_info, CLASS_NAME)
	
	return {"peer": peer, "error": error}
