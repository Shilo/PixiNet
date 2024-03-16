extends Example

@onready var ui: CanvasLayer = %UI

func _ready() -> void:
	super._ready()
	
	PixiNet.log_level = PixiNet.LogLevel.INFO

func _on_host_pressed() -> void:
	PixiNet.start_server(port)

func _on_join_pressed() -> void:
	PixiNet.start_client(address, port)

func _on_start(_id: int) -> void:
	ui.visible = false

func _on_stop(_id: int) -> void:
	ui.visible = true

func _on_server_start(id: int) -> void:
	super._on_server_start(id)
	
	add_player(id)

func _on_server_peer_start(id: int) -> void:
	super._on_server_peer_start(id)
	
	add_player(id)

func _on_server_peer_stop(id: int) -> void:
	super._on_server_peer_stop(id)
	
	remove_player(id)
