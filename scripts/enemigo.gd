extends CharacterBody2D

const EXPLOSION = preload("res://scenes/explosion.tscn")

@export var vida: int = 2
@export var velocidad: float = 90.0
@export var demora_primer_disparo: float = 1.0
@export var intervalo_disparo_min: float = 3.0
@export var intervalo_disparo_max: float = 6.0
@export var intervalo_cambio_direccion: float = 1.5
@export var potencia_bala: int = 1
@export var danio_contacto: int = 1
@export var intervalo_danio_contacto: float = 1.0
@export var es_jefe: bool = false
@export var prefab_bala: PackedScene

@onready var punto_disparo: Marker2D = $PuntoDisparo
@onready var sonido_impacto: AudioStreamPlayer2D = $SonidoImpacto

var direccion_actual: Vector2 = Vector2.DOWN
var tiempo_hasta_disparo: float
var tiempo_hasta_cambio: float = 0.0
var tiempo_hasta_danio_contacto: float = 0.0
var esta_muerto: bool = false

func _ready() -> void:
	add_to_group("enemigos")
	tiempo_hasta_disparo = demora_primer_disparo
	_elegir_direccion()

func _physics_process(delta: float) -> void:
	tiempo_hasta_danio_contacto = maxf(tiempo_hasta_danio_contacto - delta, 0.0)
	tiempo_hasta_cambio -= delta
	if tiempo_hasta_cambio <= 0.0:
		_elegir_direccion()

	velocity = direccion_actual * velocidad
	move_and_slide()
	if get_slide_collision_count() > 0:
		_revisar_danio_contacto()
		_elegir_direccion()

	tiempo_hasta_disparo -= delta
	if tiempo_hasta_disparo <= 0.0:
		disparar()
		tiempo_hasta_disparo = randf_range(intervalo_disparo_min, intervalo_disparo_max)

func _revisar_danio_contacto() -> void:
	if tiempo_hasta_danio_contacto > 0.0:
		return
	for indice in get_slide_collision_count():
		var cuerpo = get_slide_collision(indice).get_collider()
		if cuerpo is Node and cuerpo.is_in_group("jugador") and cuerpo.has_method("recibir_danio"):
			cuerpo.recibir_danio(danio_contacto)
			tiempo_hasta_danio_contacto = intervalo_danio_contacto
			return

func _elegir_direccion() -> void:
	direccion_actual = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()
	rotation = direccion_actual.angle() + PI / 2.0
	tiempo_hasta_cambio = intervalo_cambio_direccion

func disparar() -> void:
	if not prefab_bala or not punto_disparo:
		return
	var bala = prefab_bala.instantiate()
	bala.inicializar(direccion_actual, false, potencia_bala)
	get_tree().current_scene.add_child(bala)
	bala.global_position = punto_disparo.global_position

func recibir_danio(cantidad: int = 1) -> void:
	if esta_muerto:
		return
	vida -= cantidad
	if vida <= 0:
		esta_muerto = true
		crear_explosion()
		var gestor_juego = get_node_or_null("/root/GestorJuego")
		if gestor_juego:
			gestor_juego.enemigo_muerto(es_jefe)
		queue_free()
	else:
		sonido_impacto.play()

func crear_explosion() -> void:
	var explosion = EXPLOSION.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
