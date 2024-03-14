class_name PixiNetEvents extends Node

signal on_start
signal on_start_failed
signal on_stop

var _was_connected: bool = false

var _processing: bool = true
var processing: bool:
	get: return _processing
	set(value):
		_processing = value
		set_process(_processing)
		
func _init() -> void:
	update()

func _ready():
	set_process(_processing)

func _process(delta: float) -> void:
	update()

func update() -> void:
	var connected := PixiNet.connected
	if connected == _was_connected: return
	
	(on_start if connected else on_stop).emit()
	_was_connected = connected
