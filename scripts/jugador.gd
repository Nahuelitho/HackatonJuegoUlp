extends CharacterBody2D

signal vida_cambiada(vida_actual: int)

const EXPLOSION = preload("res://scenes/explosion.tscn")

@export var vida: int = 2
@export var velocidad: float = 200.0
@export var cadencia: float = 0.35
@export var esta_escondido: bool = false

@export var prefab_bala: PackedScene

@onready var punto_disparo: Marker2D = $PuntoDisparo
@onready var sprite: Sprite2D = $Sprite2D
@onready var sonido_disparo: AudioStreamPlayer2D = $SonidoDisparo
@onready var sonido_impacto: AudioStreamPlayer2D = $SonidoImpacto

var direccion_actual: Vector2 = Vector2.UP
var tiempo_proximo_disparo: float = 0.0
var potencia_bala: int = 1
var esta_muerto: bool = false

func _ready() -> void:
	add_to_group("jugador")
	vida_cambiada.emit(vida)

func _physics_process(_delta: float) -> void:
	mover()
	if Input.is_action_pressed("disparar"):
		disparar()

func mover() -> void:
	var entrada_x = Input.get_axis("mover_izq", "mover_der")
	var entrada_y = Input.get_axis("mover_arriba", "mover_abajo")

	if abs(entrada_x) > abs(entrada_y):
		entrada_y = 0.0
	else:
		entrada_x = 0.0

	var entrada = Vector2(entrada_x, entrada_y)
	if entrada != Vector2.ZERO:
		direccion_actual = entrada.normalized()
		rotation = direccion_actual.angle() + PI / 2.0

	velocity = entrada * velocidad
	move_and_slide()

func disparar() -> void:
	var ahora = Time.get_ticks_msec() / 1000.0
	if ahora < tiempo_proximo_disparo:
		return
	if not prefab_bala or not punto_disparo:
		return

	tiempo_proximo_disparo = ahora + cadencia
	var bala = prefab_bala.instantiate()
	bala.inicializar(direccion_actual, true, potencia_bala)
	get_tree().current_scene.add_child(bala)
	bala.global_position = punto_disparo.global_position
	sonido_disparo.play()

	if esta_escondido:
		cambiar_escondite(false)

func cambiar_escondite(escondido: bool) -> void:
	esta_escondido = escondido
	sprite.modulate.a = 0.4 if escondido else 1.0

func recibir_danio(cantidad: int = 1) -> void:
	if esta_muerto:
		return
	vida -= cantidad
	vida_cambiada.emit(maxi(vida, 0))
	if vida <= 0:
		esta_muerto = true
		crear_explosion()
		var gestor_juego = get_node_or_null("/root/GestorJuego")
		if gestor_juego:
			gestor_juego.jugador_murio()
		queue_free()
	else:
		sonido_impacto.play()

func crear_explosion() -> void:
	var explosion = EXPLOSION.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position

func aplicar_bonus(tipo: String) -> void:
	match tipo:
		"vida_extra":
			vida = mini(vida + 1, 2)
			vida_cambiada.emit(vida)
		"arma_mejorada":
			potencia_bala = 2
		"escudo":
			cambiar_escondite(true)
