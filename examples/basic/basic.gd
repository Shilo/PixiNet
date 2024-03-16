extends Example

func _ready() -> void:
	super._ready()

	PixiNet.start_server_or_client(address, port)

func _on_server_start(id: int) -> void:
	super._on_server_start(id)
	
	add_player(id)

func _on_server_peer_start(id: int) -> void:
	super._on_server_peer_start(id)
	
	add_player(id)

func _on_server_peer_stop(id: int) -> void:
	super._on_server_peer_stop(id)
	
	remove_player(id)
