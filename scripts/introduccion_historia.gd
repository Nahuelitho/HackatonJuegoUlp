extends Control

const TEXTOS := [
	"La guerra entre el Ejército Rojo y Ejército Azul ha sido dura y cruel desde que inició hace 7 años, cobrándose la vida de 500.000 soldados y millones en fondos estatales. Ahora, los Rojos han tomado el control de Port City, una ubicación clave por la envergadura de sus astilleros y su extenso sistema ferroviario que conecta la frontera de los dos países.",
	"Para recuperar la ciudad, se envió al escuadrón de élite \"Golden Dogs\", una división de tanques que han sido condecorados a lo largo del conflicto. Si fallan su misión, sólo Dios sabrá que alguna vez peleamos...",
]

@onready var texto: Label = $Relato/Margen/Contenido/Texto
@onready var siguiente: Button = $Relato/Margen/Contenido/Botones/Siguiente
@onready var soldados: TextureRect = $Soldados

var indice: int = 0
var siluetas_encendidas: bool = true

func _ready() -> void:
	get_tree().paused = false
	_mostrar_texto()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_avanzar()

func _on_siguiente_pressed() -> void:
	_avanzar()

func _on_saltar_pressed() -> void:
	_ir_a_la_charla()

func _on_pulso_timeout() -> void:
	siluetas_encendidas = not siluetas_encendidas
	var intensidad := 0.92 if siluetas_encendidas else 0.38
	var tween := create_tween()
	tween.tween_property(soldados, "modulate:a", intensidad, 0.42)

func _avanzar() -> void:
	if indice >= TEXTOS.size() - 1:
		_ir_a_la_charla()
		return
	indice += 1
	_mostrar_texto()

func _mostrar_texto() -> void:
	texto.text = TEXTOS[indice]
	siguiente.text = "IR A LA CHARLA" if indice == TEXTOS.size() - 1 else "SIGUIENTE"

func _ir_a_la_charla() -> void:
	get_tree().change_scene_to_file("res://scenes/cinematica_inicial.tscn")
