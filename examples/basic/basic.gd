extends Example

func _ready() -> void:
	var hosting = host()
	
	PixiNet.log_level = PixiNet.LogLevel.INFO
	
	if !hosting:
		join()
	
	super._ready()

func host() -> bool:
	var error := PixiNet.start_server(port)
	
	var success := error == OK
	if success:
		PixiNet.log("Started server. Port = %s." % port, PixiNetENetMultiplayerPeer.CLASS_NAME, PixiNet.LogLevel.INFO, true)
		add_player(multiplayer.get_unique_id())

	return success

func join() -> void:
	return PixiNet.start_client(address, port)
