extends Node2D

const MURO_ACERO = preload("res://scenes/muro_acero.tscn")
const MURO_LADRILLO = preload("res://scenes/muro_ladrillo.tscn")
const MEDIO_LADRILLO = preload("res://scenes/muro_ladrillo_medio.tscn")
const ENEMIGO = preload("res://scenes/enemigo.tscn")
const JEFE = preload("res://scenes/jefe.tscn")
const TEXTURA_TANQUE = preload("res://assets/tanques/tanque_enemigo.png")
const CRUCETA_IDLE = preload("res://assets/touch/Idle.png")
const CRUCETA_ARRIBA = preload("res://assets/touch/Up.png")
const CRUCETA_ABAJO = preload("res://assets/touch/Down.png")
const CRUCETA_IZQUIERDA = preload("res://assets/touch/Left.png")
const CRUCETA_DERECHA = preload("res://assets/touch/Right.png")

@onready var muros: Node2D = $Muros
@onready var jugador = $Jugador
@onready var corazon_1: TextureRect = $Interfaz/Corazon1
@onready var corazon_2: TextureRect = $Interfaz/Corazon2
@onready var cruceta: Sprite2D = $Interfaz/Cruceta
@onready var icono_disparo: Sprite2D = $Interfaz/Disparar/Fondo
@onready var contador_tanques: GridContainer = $Interfaz/ContadorTanques
@onready var texto_restantes: Label = $Interfaz/Restantes
@onready var resultado: Control = $Interfaz/Resultado
@onready var titulo_resultado: Label = $Interfaz/Resultado/Panel/Contenido/Titulo

var enemigos_generados: int = 3
var iconos_enemigos: Array[TextureRect] = []

func _ready() -> void:
	_crear_borde_de_acero()
	_crear_dibujo_central()
	_crear_refugio_base()
	_crear_contador_enemigos()
	jugador.vida_cambiada.connect(_actualizar_vida)
	_actualizar_vida(jugador.vida)
	GestorJuego.enemigos_actualizados.connect(_actualizar_contador)
	GestorJuego.enemigo_eliminado.connect(_on_enemigo_eliminado)
	GestorJuego.partida_finalizada.connect(_mostrar_resultado)
	GestorJuego.iniciar_partida()

func _process(_delta: float) -> void:
	cruceta.texture = CRUCETA_IDLE
	if Input.is_action_pressed("mover_arriba"):
		cruceta.texture = CRUCETA_ARRIBA
	elif Input.is_action_pressed("mover_abajo"):
		cruceta.texture = CRUCETA_ABAJO
	elif Input.is_action_pressed("mover_izq"):
		cruceta.texture = CRUCETA_IZQUIERDA
	elif Input.is_action_pressed("mover_der"):
		cruceta.texture = CRUCETA_DERECHA
	icono_disparo.modulate = Color.WHITE if Input.is_action_pressed("disparar") else Color(0.72, 0.72, 0.72, 1.0)

func _crear_borde_de_acero() -> void:
	for x in range(344, 921, 48):
		_agregar_muro(MURO_ACERO, Vector2(x, 64))
		_agregar_muro(MURO_ACERO, Vector2(x, 656))
	for y in range(112, 609, 48):
		_agregar_muro(MURO_ACERO, Vector2(344, y))
		_agregar_muro(MURO_ACERO, Vector2(920, y))

func _crear_dibujo_central() -> void:
	# Hueso de ladrillos: mantiene caminos libres alrededor para los tanques.
	for x in range(544, 737, 48):
		_agregar_muro(MURO_LADRILLO, Vector2(x, 352))
	for posicion in [Vector2(520, 304), Vector2(520, 400), Vector2(760, 304), Vector2(760, 400)]:
		_agregar_muro(MURO_LADRILLO, posicion)

func _crear_refugio_base() -> void:
	for x in [604, 628, 652, 676]:
		_agregar_muro(MEDIO_LADRILLO, Vector2(x, 584), PI / 2.0)
	for y in [608, 632]:
		_agregar_muro(MEDIO_LADRILLO, Vector2(580, y))
		_agregar_muro(MEDIO_LADRILLO, Vector2(700, y))

func _agregar_muro(escena: PackedScene, posicion: Vector2, rotacion: float = 0.0) -> void:
	var muro = escena.instantiate()
	muros.add_child(muro)
	muro.position = posicion
	muro.rotation = rotacion

func _actualizar_vida(vida_actual: int) -> void:
	corazon_1.visible = vida_actual >= 1
	corazon_2.visible = vida_actual >= 2

func _crear_contador_enemigos() -> void:
	var region_tanque = AtlasTexture.new()
	region_tanque.atlas = TEXTURA_TANQUE
	region_tanque.region = Rect2(38, 25, 24, 50)
	for indice in GestorJuego.OBJETIVO_ENEMIGOS:
		var icono = TextureRect.new()
		icono.custom_minimum_size = Vector2(32, 42)
		icono.texture = region_tanque
		icono.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icono.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if indice == GestorJuego.OBJETIVO_ENEMIGOS - 1:
			icono.modulate = Color(1.0, 0.75, 0.15, 1.0)
		contador_tanques.add_child(icono)
		iconos_enemigos.append(icono)

func _actualizar_contador(restantes: int) -> void:
	texto_restantes.text = "ENEMIGOS: %d" % restantes
	var eliminados = GestorJuego.OBJETIVO_ENEMIGOS - restantes
	for indice in iconos_enemigos.size():
		iconos_enemigos[indice].modulate.a = 0.2 if indice < eliminados else 1.0

func _on_enemigo_eliminado(total_eliminados: int) -> void:
	if total_eliminados < GestorJuego.ENEMIGOS_ANTES_DEL_JEFE and enemigos_generados < GestorJuego.ENEMIGOS_ANTES_DEL_JEFE:
		_spawnear_enemigo(ENEMIGO)
		enemigos_generados += 1
	elif total_eliminados == GestorJuego.ENEMIGOS_ANTES_DEL_JEFE:
		_spawnear_enemigo(JEFE, Vector2(640, 130))

func _spawnear_enemigo(escena: PackedScene, posicion: Vector2 = Vector2.ZERO) -> void:
	var enemigo = escena.instantiate()
	add_child(enemigo)
	enemigo.global_position = posicion if posicion != Vector2.ZERO else [Vector2(400, 120), Vector2(640, 120), Vector2(880, 120)].pick_random()

func _mostrar_resultado(gano: bool) -> void:
	titulo_resultado.text = "VICTORIA" if gano else "DERROTA"
	titulo_resultado.modulate = Color(1.0, 0.76, 0.2, 1.0) if gano else Color(1.0, 0.3, 0.25, 1.0)
	resultado.visible = true

func _on_reintentar_pressed() -> void:
	GestorJuego.reiniciar_partida()

func _on_inicio_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
