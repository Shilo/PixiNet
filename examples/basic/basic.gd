extends Example

func _ready() -> void:
	super._ready()
	
	var host_error = PixiNet.start_server(port)
	PixiNet.log_level = PixiNet.LogLevel.INFO
	
	if host_error:
		PixiNet.start_client(address, port)

func _on_start(id: int) -> void:
	super._on_start(id)
	
	add_player(id)

func _on_stop(id: int) -> void:
	super._on_stop(id)
	
	remove_players()
