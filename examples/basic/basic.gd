extends Node2D

@export var IP_ADDRESS: String = PixiNet.DEFAULT_ADDRESS
@export var PORT: int = PixiNet.DEFAULT_PORT

func _ready() -> void:
	var hosting = host()
	
	PixiNet.log_level = PixiNet.LogLevel.INFO
	
	if !hosting:
		join()

func host() -> bool:
	var error := PixiNet.start_server(PORT)
	
	var success := error == OK
	if success:
		PixiNet.log("Started server. Port = %s." % PORT, PixiNetENetMultiplayerPeer.CLASS_NAME, PixiNet.LogLevel.INFO, true)

	return success

func join() -> void:
	return PixiNet.start_client(IP_ADDRESS, PORT)
