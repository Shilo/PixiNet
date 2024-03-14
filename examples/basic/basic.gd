extends Example

func _ready() -> void:
	super._ready()
	
	PixiNet.log_info("Connecting...", "", true)
	
	var host_error = PixiNet.start_server(port)
	PixiNet.log_level = PixiNet.LogLevel.WARN
	
	if host_error:
		PixiNet.start_client(address, port)

func _on_start(id: int) -> void:
	super._on_start(id)
	
	#if is_multiplayer_authority():
		#add_player(id)

func _on_stop(id: int) -> void:
	super._on_stop(id)
	
	remove_players()

func _on_peer_start(id: int) -> void:
	super._on_peer_start(id)
	
	add_player(id)

func _on_peer_stop(id: int) -> void:
	super._on_peer_stop(id)
