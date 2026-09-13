extends CharacterBody2D

signal vida_cambiada(vida_actual: int)

const EXPLOSION = preload("res://scenes/explosion.tscn")

var vida: int = 2
@export var velocidad: float = 200.0
@export var cadencia: float = 0.35

@export var prefab_bala: PackedScene

@onready var punto_disparo: Marker2D = $PuntoDisparo
@onready var sonido_disparo: AudioStreamPlayer2D = $SonidoDisparo
@onready var sonido_impacto: AudioStreamPlayer2D = $SonidoImpacto
@onready var aura_escudo: Line2D = $AuraEscudo

var direccion_actual: Vector2 = Vector2.UP
var tiempo_proximo_disparo: float = 0.0
var esta_muerto: bool = false
var vida_maxima: int = 2
var escudo_activo: bool = false

func _ready() -> void:
	add_to_group("jugador")
	vida_maxima = GestorJuego.obtener_vidas_iniciales()
	vida = vida_maxima
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
	bala.inicializar(direccion_actual, true)
	get_tree().current_scene.add_child(bala)
	bala.global_position = punto_disparo.global_position
	sonido_disparo.play()

func recibir_danio(cantidad: int = 1) -> void:
	if esta_muerto:
		return
	_aplicar_danio(cantidad)

func recibir_impacto_bala(cantidad: int = 1) -> void:
	if esta_muerto:
		return
	if escudo_activo:
		escudo_activo = false
		aura_escudo.visible = false
		sonido_impacto.play()
		return
	_aplicar_danio(cantidad)

func _aplicar_danio(cantidad: int) -> void:
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
			vida = mini(vida + 1, vida_maxima)
			vida_cambiada.emit(vida)
		"escudo":
			escudo_activo = true
			aura_escudo.visible = true
