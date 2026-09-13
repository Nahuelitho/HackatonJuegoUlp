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
@onready var sensor_frontal: RayCast2D = $SensorFrontal

var direccion_actual: Vector2 = Vector2.DOWN
var tiempo_hasta_disparo: float
var tiempo_hasta_cambio: float = 0.0
var tiempo_hasta_danio_contacto: float = 0.0
var esta_muerto: bool = false
var ultima_posicion_segura: Vector2
var tiempo_sin_avanzar: float = 0.0

func _ready() -> void:
	add_to_group("enemigos")
	ultima_posicion_segura = global_position
	tiempo_hasta_disparo = demora_primer_disparo
	_elegir_direccion()

func _physics_process(delta: float) -> void:
	var posicion_anterior := global_position
	tiempo_hasta_danio_contacto = maxf(tiempo_hasta_danio_contacto - delta, 0.0)
	tiempo_hasta_cambio -= delta
	if tiempo_hasta_cambio <= 0.0:
		_elegir_direccion()
	if sensor_frontal.is_colliding():
		_girar_antes_del_obstaculo()

	velocity = direccion_actual * velocidad
	move_and_slide()
	if get_slide_collision_count() > 0:
		_revisar_danio_contacto()
		_alejarse_de_colision()
	else:
		ultima_posicion_segura = global_position
	_actualizar_bloqueo(posicion_anterior, delta)

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

func _alejarse_de_colision() -> void:
	var normal := get_slide_collision(0).get_normal()
	global_position += normal * 1.0
	direccion_actual = _elegir_direccion_libre()
	rotation = direccion_actual.angle() + PI / 2.0
	tiempo_hasta_cambio = intervalo_cambio_direccion

func _girar_antes_del_obstaculo() -> void:
	direccion_actual = _elegir_direccion_libre()
	rotation = direccion_actual.angle() + PI / 2.0
	tiempo_hasta_cambio = intervalo_cambio_direccion

func _elegir_direccion_libre() -> Vector2:
	var opciones := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	opciones.shuffle()
	var espacio := get_world_2d().direct_space_state
	for direccion in opciones:
		if direccion == direccion_actual:
			continue
		var consulta := PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + direccion * 64.0,
			collision_mask,
			[get_rid()]
		)
		if espacio.intersect_ray(consulta).is_empty():
			return direccion
	return -direccion_actual

func _actualizar_bloqueo(posicion_anterior: Vector2, delta: float) -> void:
	if global_position.distance_to(posicion_anterior) < 0.5:
		tiempo_sin_avanzar += delta
	else:
		tiempo_sin_avanzar = 0.0
	if tiempo_sin_avanzar < 0.45:
		return
	global_position = ultima_posicion_segura
	direccion_actual = _elegir_direccion_libre()
	rotation = direccion_actual.angle() + PI / 2.0
	tiempo_hasta_cambio = intervalo_cambio_direccion
	tiempo_sin_avanzar = 0.0
	sensor_frontal.force_raycast_update()

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
