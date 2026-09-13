extends Node2D

@export_enum("Facil", "Medio", "Dificil") var dificultad_nivel: int = 0

const ENEMIGO = preload("res://scenes/enemigo.tscn")
const JEFE = preload("res://scenes/jefe.tscn")
const TEXTURA_TANQUE = preload("res://assets/tanques/tanque_enemigo.png")
const CRUCETA_IDLE = preload("res://assets/touch/Idle.png")
const CRUCETA_ARRIBA = preload("res://assets/touch/Up.png")
const CRUCETA_ABAJO = preload("res://assets/touch/Down.png")
const CRUCETA_IZQUIERDA = preload("res://assets/touch/Left.png")
const CRUCETA_DERECHA = preload("res://assets/touch/Right.png")

@onready var jugador = $Jugador
@onready var corazon_1: TextureRect = $Interfaz/Corazon1
@onready var corazon_2: TextureRect = $Interfaz/Corazon2
@onready var corazon_3: TextureRect = $Interfaz/Corazon3
@onready var cruceta: Sprite2D = $Interfaz/Cruceta
@onready var icono_disparo: Sprite2D = $Interfaz/Disparar/Fondo
@onready var contador_tanques: GridContainer = $Interfaz/ContadorTanques
@onready var cronometro: Label = $Interfaz/Cronometro
@onready var texto_restantes: Label = $Interfaz/Restantes
@onready var resultado: Control = $Interfaz/Resultado
@onready var titulo_resultado: Label = $Interfaz/Resultado/Panel/Contenido/Titulo
@onready var tiempo_resultado: Label = $Interfaz/Resultado/Panel/Contenido/TiempoJugado
@onready var sonido_victoria: AudioStreamPlayer = $SonidoVictoria
@onready var sonido_derrota: AudioStreamPlayer = $SonidoDerrota

var enemigos_generados: int = 3
var iconos_enemigos: Array[TextureRect] = []
var tiempo_jugado: float = 0.0

func _enter_tree() -> void:
	GestorJuego.seleccionar_dificultad(dificultad_nivel)

func _ready() -> void:
	ReproductorMusica.reproducir()
	_cargar_mapa_seleccionado()
	_crear_contador_enemigos()
	jugador.vida_cambiada.connect(_actualizar_vida)
	_actualizar_vida(jugador.vida)
	GestorJuego.enemigos_actualizados.connect(_actualizar_contador)
	GestorJuego.enemigo_eliminado.connect(_on_enemigo_eliminado)
	GestorJuego.partida_finalizada.connect(_mostrar_resultado)
	GestorJuego.iniciar_partida()

func _cargar_mapa_seleccionado() -> void:
	var ruta_mapa := GestorJuego.obtener_ruta_mapa()
	if ruta_mapa == "res://scenes/mapa_nivel_facil.tscn":
		return
	var mapa_actual := get_node_or_null("Muros")
	if mapa_actual:
		mapa_actual.free()
	var mapa_previsualizado := get_node_or_null("VistaMapa")
	if mapa_previsualizado:
		mapa_previsualizado.name = "Muros"
		return
	var escena_mapa := load(ruta_mapa) as PackedScene
	if escena_mapa:
		var mapa = escena_mapa.instantiate()
		mapa.name = "Muros"
		add_child(mapa)
		move_child(mapa, $BaseAguila.get_index())

func _process(delta: float) -> void:
	if not GestorJuego.partida_terminada and not GestorJuego.finalizando_partida:
		tiempo_jugado += delta
	cronometro.text = "TIEMPO: %s" % _formatear_tiempo(tiempo_jugado)
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

func _actualizar_vida(vida_actual: int) -> void:
	corazon_1.visible = vida_actual >= 1
	corazon_2.visible = vida_actual >= 2
	corazon_3.visible = vida_actual >= 3

func _crear_contador_enemigos() -> void:
	var objetivo := GestorJuego.obtener_objetivo_enemigos()
	var region_tanque = AtlasTexture.new()
	region_tanque.atlas = TEXTURA_TANQUE
	region_tanque.region = Rect2(38, 25, 24, 50)
	for indice in objetivo:
		var icono = TextureRect.new()
		icono.custom_minimum_size = Vector2(32, 42)
		icono.texture = region_tanque
		icono.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icono.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icono.modulate = Color(1.0, 0.55, 0.55, 1.0)
		if indice == objetivo - 1:
			icono.modulate = Color(1.0, 0.08, 0.03, 1.0)
		contador_tanques.add_child(icono)
		iconos_enemigos.append(icono)

func _actualizar_contador(restantes: int) -> void:
	texto_restantes.text = "ENEMIGOS: %d" % restantes
	var eliminados = GestorJuego.obtener_objetivo_enemigos() - restantes
	for indice in iconos_enemigos.size():
		iconos_enemigos[indice].modulate.a = 0.2 if indice < eliminados else 1.0

func _on_enemigo_eliminado(total_eliminados: int) -> void:
	var antes_del_jefe := GestorJuego.obtener_objetivo_enemigos() - 1
	if total_eliminados < antes_del_jefe and enemigos_generados < antes_del_jefe:
		_spawnear_enemigo.call_deferred(ENEMIGO)
		enemigos_generados += 1
	elif total_eliminados == antes_del_jefe:
		_spawnear_enemigo.call_deferred(JEFE, Vector2(640, 130))

func _spawnear_enemigo(escena: PackedScene, posicion: Vector2 = Vector2.ZERO) -> void:
	var enemigo = escena.instantiate()
	add_child(enemigo)
	enemigo.global_position = posicion if posicion != Vector2.ZERO else [Vector2(400, 120), Vector2(640, 120), Vector2(880, 120)].pick_random()

func _mostrar_resultado(gano: bool) -> void:
	ReproductorMusica.detener()
	if gano:
		sonido_victoria.play()
	else:
		sonido_derrota.play()
	titulo_resultado.text = "VICTORIA" if gano else "DERROTA"
	titulo_resultado.modulate = Color(1.0, 0.76, 0.2, 1.0) if gano else Color(1.0, 0.3, 0.25, 1.0)
	tiempo_resultado.text = "TIEMPO JUGADO: %s" % _formatear_tiempo(tiempo_jugado)
	resultado.visible = true

func _formatear_tiempo(tiempo: float) -> String:
	var segundos_totales := int(tiempo)
	return "%02d:%02d" % [floori(segundos_totales / 60.0), segundos_totales % 60]

func _on_reintentar_pressed() -> void:
	GestorJuego.reiniciar_partida()

func _on_inicio_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
