extends Control

const JOHN_NORMAL = preload("res://assets/soldado/soldado1_1.png")
const JOHN_HABLANDO = preload("res://assets/soldado/soldado1_2.png")
const CABO_NORMAL = preload("res://assets/soldado/soldado2_1.png")
const CABO_HABLANDO = preload("res://assets/soldado/soldado2_2.png")

const DIALOGOS := [
	{"hablante": 0, "nombre": "SGT. JOHN", "texto": "Hemos llegado, Cabo. Estate listo."},
	{"hablante": 1, "nombre": "CABO", "texto": "Señor, antes de venir, escuché al sargento Miller decir que los ciudadanos y milicias que evacuaron dejaron distintos suministros. Según dijo, están entre paredes agrietadas."},
	{"hablante": 0, "nombre": "SGT. JOHN", "texto": "Pues bien, vigilaré el perímetro. Ten el cañón siempre cargado. Ah, y una cosa más."},
	{"hablante": 1, "nombre": "CABO", "texto": "Soy todo oídos, señor."},
	{"hablante": 0, "nombre": "SGT. JOHN", "texto": "¡Hostiles a las doce!"},
]

@onready var soldado_izquierdo: TextureRect = $SoldadoIzquierdo
@onready var soldado_derecho: TextureRect = $SoldadoDerecho
@onready var nombre: Label = $Dialogo/Margen/Contenido/Nombre
@onready var texto: Label = $Dialogo/Margen/Contenido/Texto
@onready var siguiente: Button = $Dialogo/Margen/Contenido/Botones/Siguiente

var indice: int = 0
var pose_hablando: bool = false

func _ready() -> void:
	get_tree().paused = false
	_mostrar_dialogo()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_avanzar()

func _on_animacion_timeout() -> void:
	pose_hablando = not pose_hablando
	_actualizar_poses()

func _on_siguiente_pressed() -> void:
	_avanzar()

func _on_saltar_pressed() -> void:
	_ir_al_juego()

func _avanzar() -> void:
	if indice >= DIALOGOS.size() - 1:
		_ir_al_juego()
		return
	indice += 1
	pose_hablando = true
	_mostrar_dialogo()

func _mostrar_dialogo() -> void:
	var dialogo: Dictionary = DIALOGOS[indice]
	nombre.text = dialogo.nombre
	texto.text = dialogo.texto
	siguiente.text = "IR AL JUEGO" if indice == DIALOGOS.size() - 1 else "SIGUIENTE"
	_actualizar_poses()

func _actualizar_poses() -> void:
	var habla_john: bool = DIALOGOS[indice].hablante == 0
	soldado_izquierdo.texture = JOHN_HABLANDO if habla_john and pose_hablando else JOHN_NORMAL
	soldado_derecho.texture = CABO_HABLANDO if not habla_john and pose_hablando else CABO_NORMAL
	soldado_izquierdo.modulate = Color.WHITE if habla_john else Color(0.48, 0.48, 0.48, 0.82)
	soldado_derecho.modulate = Color.WHITE if not habla_john else Color(0.48, 0.48, 0.48, 0.82)

func _ir_al_juego() -> void:
	get_tree().change_scene_to_file(GestorJuego.obtener_ruta_nivel())
