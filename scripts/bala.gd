extends Area2D

@export var velocidad: float = 400.0
@export var tiempo_de_vida: float = 3.0

var direccion: Vector2 = Vector2.UP
var es_de_jugador: bool = true
var potencia: int = 1

func inicializar(dir: Vector2, de_jugador: bool, potencia_bala: int = 1) -> void:
	direccion = dir.normalized()
	es_de_jugador = de_jugador
	potencia = potencia_bala
	collision_layer = 8 if es_de_jugador else 16
	collision_mask = 5 if es_de_jugador else 3
	rotation = direccion.angle() + PI / 2.0
	if potencia > 1:
		scale *= 1.5

func _physics_process(delta: float) -> void:
	global_position += direccion * velocidad * delta
	tiempo_de_vida -= delta
	if tiempo_de_vida <= 0.0:
		queue_free()

func _on_body_entered(cuerpo: Node) -> void:
	if es_de_jugador and cuerpo.is_in_group("jugador"):
		return
	if not es_de_jugador and cuerpo.is_in_group("enemigos"):
		return

	if cuerpo.has_method("romper_muro"):
		cuerpo.romper_muro(es_de_jugador, potencia > 1)
	elif cuerpo.has_method("recibir_danio"):
		cuerpo.recibir_danio(potencia)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("romper_muro"):
		area.romper_muro(es_de_jugador, potencia > 1)
	queue_free()
