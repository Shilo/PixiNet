extends Node2D

@export var IP_ADDRESS: String = PixiNet.DEFAULT_ADDRESS
@export var PORT: int = PixiNet.DEFAULT_PORT

func _ready() -> void:
	PixiNet.log_level = PixiNet.LogLevel.INFO
	if !host():
		join()

func host() -> bool:
	var error := PixiNet.start_server(PORT)
	return error == OK

func join():
	return PixiNet.start_client(IP_ADDRESS, PORT)
