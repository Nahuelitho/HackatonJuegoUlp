extends Control

func _ready() -> void:
	get_tree().paused = false
	ReproductorMusica.detener()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_continuar()

func _on_continuar_pressed() -> void:
	_continuar()

func _continuar() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
