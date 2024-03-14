class_name PixiNetEvents extends Node

signal on_connection_failed
signal on_connected
signal on_disconnected

var _was_connected: bool = false

func _init() -> void:
	update()
	
func _process(delta: float) -> void:
	update()

func update() -> void:
	var connected := PixiNet.connected
	if connected == _was_connected: return
	
	(on_connected if connected else on_disconnected).emit()
	_was_connected = connected
