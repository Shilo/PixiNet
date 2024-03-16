extends Example

@onready var menu: Control = %Menu
@onready var hud: Control = %HUD
@onready var host_button: Button = %Host
@onready var join_button: Button = %Join

func _ready() -> void:
	super._ready()
	
	PixiNet.log_level = PixiNet.LogLevel.WARN
	set_menu_visibility(true)

func _on_host_pressed() -> void:
	host_button.disabled = true
	join_button.disabled = false
	
	PixiNet.start_server(port)

func _on_join_pressed() -> void:
	join_button.disabled = true
	host_button.disabled = false
	
	PixiNet.start_client(address, port)

func _on_start_failed(error: Error, was_server: bool) -> void:
	super._on_start_failed(error, was_server)
	
	set_menu_visibility(true)

func _on_start(_id: int) -> void:
	set_menu_visibility(false)

func _on_stop(_id: int) -> void:
	remove_players()
	set_menu_visibility(true)

func _on_exit_pressed() -> void:
	PixiNet.stop()

func _on_server_start(id: int) -> void:
	super._on_server_start(id)
	
	add_player(id)

func _on_server_peer_start(id: int) -> void:
	super._on_server_peer_start(id)
	
	add_player(id)

func _on_server_peer_stop(id: int) -> void:
	super._on_server_peer_stop(id)
	
	remove_player(id)

func set_menu_visibility(visible: bool) -> void:
	menu.visible = visible
	hud.visible = !visible
	host_button.disabled = false
	join_button.disabled = false

func _on_quit_pressed() -> void:
	get_tree().quit()
