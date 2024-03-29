extends Example

@export var auto_start: bool = false

@onready var menu: Control = %Menu
@onready var hud: Control = %HUD
@onready var host_button: Button = %Host
@onready var join_button: Button = %Join
@onready var password_edit: LineEdit = %Password

var _password: String
var password: String:
	get:
		return _password if _password else " "

func _ready() -> void:
	super._ready()
	
	PixiNet.log_level = PixiNet.LogLevel.INFO
	PixiNet.multiplayer.auth_callback = on_authenticate
	
	set_menu_visibility(true)
	
	if auto_start:
		start_server_client()

func start_server_client() -> void:
	host_button.disabled = true
	join_button.disabled = true
	password_edit.editable = false
	_password = password_edit.text
	
	PixiNet.start_server_or_client(address, port)
	
func _on_host_pressed() -> void:
	host_button.disabled = true
	join_button.disabled = false
	password_edit.editable = false
	_password = password_edit.text
	
	PixiNet.start_server(port)

func _on_join_pressed() -> void:
	join_button.disabled = true
	host_button.disabled = false
	password_edit.editable = false
	_password = password_edit.text
	
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
	password_edit.editable = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_peer_authenticating(id: int) -> void:
	super._on_peer_authenticating(id)
	if multiplayer.is_server():
		if !_password:
			multiplayer.complete_auth(id)
		return
	
	PixiNet.multiplayer.send_auth(id, password.to_utf8_buffer())
	multiplayer.complete_auth(id)
	
func on_authenticate(peer: int, data: PackedByteArray) -> void:
	if !multiplayer.is_server() || !_password: return
	var password: String = data.get_string_from_ascii()
	
	if !_password || password == _password:
		multiplayer.complete_auth(peer)
	else:
		multiplayer.multiplayer_peer.disconnect_peer(peer)

func _on_peer_authentication_failed(id: int) -> void:
	super._on_peer_authentication_failed(id)
	if multiplayer.is_server(): return
	
	set_menu_visibility(true)
