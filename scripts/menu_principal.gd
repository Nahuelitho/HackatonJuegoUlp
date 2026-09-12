extends Control

@onready var panel_opciones: PanelContainer = $PanelOpciones
@onready var panel_niveles: PanelContainer = $PanelNiveles
@onready var volumen: HSlider = $PanelOpciones/Margen/Opciones/Volumen
@onready var silencio: CheckButton = $PanelOpciones/Margen/Opciones/Silencio

func _ready() -> void:
	get_tree().paused = false
	var indice_master = AudioServer.get_bus_index("Master")
	volumen.value = db_to_linear(AudioServer.get_bus_volume_db(indice_master)) * 100.0
	silencio.button_pressed = AudioServer.is_bus_mute(indice_master)

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nivel_prueba.tscn")

func _on_opciones_pressed() -> void:
	panel_niveles.visible = false
	panel_opciones.visible = true

func _on_niveles_pressed() -> void:
	panel_opciones.visible = false
	panel_niveles.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_cerrar_opciones_pressed() -> void:
	panel_opciones.visible = false

func _on_cerrar_niveles_pressed() -> void:
	panel_niveles.visible = false

func _on_nivel_facil_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nivel_prueba.tscn")

func _on_volumen_value_changed(valor: float) -> void:
	var indice_master = AudioServer.get_bus_index("Master")
	var volumen_lineal = maxf(valor / 100.0, 0.0001)
	AudioServer.set_bus_volume_db(indice_master, linear_to_db(volumen_lineal))

func _on_silencio_toggled(activado: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), activado)
