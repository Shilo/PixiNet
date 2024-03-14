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
		add_player(multiplayer.get_unique_id())

	return success

func join() -> void:
	return PixiNet.start_client(address, port)

func _on_connected() -> void:
	PixiNet.log("on connected", "Basic")

func _on_disconnected() -> void:
	PixiNet.log("on DISconnected", "Basic")
	remove_players()
