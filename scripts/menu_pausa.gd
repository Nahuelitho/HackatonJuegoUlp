extends CanvasLayer

@onready var capa_pausa: Control = $CapaPausa
@onready var menu_principal: VBoxContainer = $CapaPausa/Panel/Margen/Contenido/Menu
@onready var opciones: VBoxContainer = $CapaPausa/Panel/Margen/Contenido/Opciones
@onready var informacion: VBoxContainer = $CapaPausa/Panel/Margen/Contenido/Informacion
@onready var volumen: HSlider = $CapaPausa/Panel/Margen/Contenido/Opciones/Volumen
@onready var silencio: CheckButton = $CapaPausa/Panel/Margen/Contenido/Opciones/Silencio
@onready var boton_pausa: Button = $BotonPausa

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var indice_master = AudioServer.get_bus_index("Master")
	volumen.value = db_to_linear(AudioServer.get_bus_volume_db(indice_master)) * 100.0
	silencio.button_pressed = AudioServer.is_bus_mute(indice_master)
	GestorJuego.partida_finalizada.connect(_on_partida_finalizada)

func _on_pausa_pressed() -> void:
	if GestorJuego.partida_terminada or GestorJuego.finalizando_partida:
		return
	capa_pausa.visible = true
	menu_principal.visible = true
	opciones.visible = false
	informacion.visible = false
	get_tree().paused = true

func _on_continuar_pressed() -> void:
	get_tree().paused = false
	capa_pausa.visible = false

func _on_opciones_pressed() -> void:
	menu_principal.visible = false
	opciones.visible = true
	informacion.visible = false

func _on_informacion_pressed() -> void:
	menu_principal.visible = false
	opciones.visible = false
	informacion.visible = true

func _on_volver_opciones_pressed() -> void:
	opciones.visible = false
	menu_principal.visible = true

func _on_volver_informacion_pressed() -> void:
	informacion.visible = false
	menu_principal.visible = true

func _on_inicio_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

func _on_volumen_value_changed(valor: float) -> void:
	var volumen_lineal = maxf(valor / 100.0, 0.0001)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volumen_lineal))

func _on_silencio_toggled(activado: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), activado)

func _on_partida_finalizada(_gano: bool) -> void:
	capa_pausa.visible = false
	boton_pausa.visible = false
