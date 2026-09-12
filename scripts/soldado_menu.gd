extends AnimatedSprite2D

const TEXTURA = preload("res://assets/soldado/Black_Soldier.png")
const TAMANIO_CELDA = Vector2(116, 67)

func _ready() -> void:
	_configurar_animaciones()
	_reproducir_secuencia()

func _configurar_animaciones() -> void:
	var cuadros = SpriteFrames.new()
	cuadros.remove_animation("default")
	_agregar_animacion(cuadros, "correr", [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)], 9.0)
	_agregar_animacion(cuadros, "disparar", [Vector2i(0, 3), Vector2i(1, 3), Vector2i(0, 4), Vector2i(1, 4)], 7.0)
	sprite_frames = cuadros

func _agregar_animacion(cuadros: SpriteFrames, nombre: StringName, celdas: Array[Vector2i], velocidad: float) -> void:
	cuadros.add_animation(nombre)
	cuadros.set_animation_loop(nombre, false)
	cuadros.set_animation_speed(nombre, velocidad)
	for celda in celdas:
		var cuadro = AtlasTexture.new()
		cuadro.atlas = TEXTURA
		cuadro.region = Rect2(Vector2(celda) * TAMANIO_CELDA, TAMANIO_CELDA)
		cuadros.add_frame(nombre, cuadro)

func _reproducir_secuencia() -> void:
	while is_inside_tree():
		play("correr")
		await animation_finished
		play("disparar")
		await animation_finished
