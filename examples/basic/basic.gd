extends Example

func _ready() -> void:
	super._ready()
	
	var hosting = host()
	
	PixiNet.log_level = PixiNet.LogLevel.INFO
	
	if !hosting:
		join()

func host() -> bool:
	var error := PixiNet.start_server(port)
	
	var success := error == OK
	if success:
		PixiNet.log("Started server. Port = %s." % port, PixiNetENetMultiplayerPeer.CLASS_NAME, PixiNet.LogLevel.INFO, true)

	return success

func join() -> void:
	return PixiNet.start_client(address, port)

func _on_start(id: int) -> void:
	print("_on_start: %d" % id)
	add_player(id)

func _on_stop() -> void:
	print("_on_stop")
	remove_players()

func _on_peer_start(id: int) -> void:
	print("_on_peer_start: %d" % id)

func _on_peer_stop(id: int) -> void:
	print("_on_peer_stop: %d" % id)
