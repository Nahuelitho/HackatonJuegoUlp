extends Node2D

const MURO_ACERO = preload("res://scenes/muro_acero.tscn")
const MURO_LADRILLO = preload("res://scenes/muro_ladrillo.tscn")
const MEDIO_LADRILLO = preload("res://scenes/muro_ladrillo_medio.tscn")

@onready var muros: Node2D = $Muros

func _ready() -> void:
	_crear_borde_de_acero()
	_crear_dibujo_central()
	_crear_refugio_base()

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
