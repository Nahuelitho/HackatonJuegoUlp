extends Control

@onready var panel_opciones: PanelContainer = $PanelOpciones
@onready var panel_niveles: PanelContainer = $PanelNiveles
@onready var fondo_modal: ColorRect = $FondoModal
@onready var volumen: HSlider = $PanelOpciones/Margen/Opciones/Volumen
@onready var silencio: CheckButton = $PanelOpciones/Margen/Opciones/Silencio
@onready var boton_audio: Button = $BotonAudio

func _ready() -> void:
	get_tree().paused = false
	ReproductorMusica.reproducir()
	var indice_master = AudioServer.get_bus_index("Master")
	volumen.value = db_to_linear(AudioServer.get_bus_volume_db(indice_master)) * 100.0
	silencio.button_pressed = AudioServer.is_bus_mute(indice_master)
	_actualizar_boton_audio()

func _on_iniciar_pressed() -> void:
	GestorJuego.seleccionar_dificultad(GestorJuego.Dificultad.FACIL)
	get_tree().change_scene_to_file("res://scenes/cinematica_inicial.tscn")

func _on_opciones_pressed() -> void:
	panel_niveles.visible = false
	panel_opciones.visible = true
	fondo_modal.visible = true

func _on_niveles_pressed() -> void:
	panel_opciones.visible = false
	panel_niveles.visible = true
	fondo_modal.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_cerrar_opciones_pressed() -> void:
	panel_opciones.visible = false
	fondo_modal.visible = false

func _on_cerrar_niveles_pressed() -> void:
	panel_niveles.visible = false
	fondo_modal.visible = false

func _on_nivel_facil_pressed() -> void:
	_iniciar_nivel(GestorJuego.Dificultad.FACIL)

func _on_nivel_medio_pressed() -> void:
	_iniciar_nivel(GestorJuego.Dificultad.MEDIO)

func _on_nivel_dificil_pressed() -> void:
	_iniciar_nivel(GestorJuego.Dificultad.DIFICIL)

func _iniciar_nivel(dificultad: int) -> void:
	GestorJuego.seleccionar_dificultad(dificultad)
	get_tree().change_scene_to_file(GestorJuego.obtener_ruta_nivel())

func _on_volumen_value_changed(valor: float) -> void:
	var indice_master = AudioServer.get_bus_index("Master")
	var volumen_lineal = maxf(valor / 100.0, 0.0001)
	AudioServer.set_bus_volume_db(indice_master, linear_to_db(volumen_lineal))

func _on_silencio_toggled(activado: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), activado)
	_actualizar_boton_audio()

func _on_boton_audio_pressed() -> void:
	var indice_master = AudioServer.get_bus_index("Master")
	var nuevo_estado = not AudioServer.is_bus_mute(indice_master)
	AudioServer.set_bus_mute(indice_master, nuevo_estado)
	silencio.set_pressed_no_signal(nuevo_estado)
	_actualizar_boton_audio()

func _actualizar_boton_audio() -> void:
	boton_audio.text = "X" if AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")) else "♪"
