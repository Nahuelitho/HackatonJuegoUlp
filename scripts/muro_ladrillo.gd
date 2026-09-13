extends StaticBody2D

const TEXTURA_DANADA = preload("res://assets/escenario/pared dañada.png")

@export var vida: int = 2

@onready var sprite: Sprite2D = $Sprite2D

func romper_muro(_es_de_jugador: bool, impacto_fuerte: bool = false) -> void:
	vida -= 2 if impacto_fuerte else 1
	if vida > 0:
		sprite.texture = TEXTURA_DANADA
		sprite.modulate = Color(0.72, 0.72, 0.72, 1.0)
		return

	var gestor_bonus = get_tree().get_first_node_in_group("gestor_bonus")
	if gestor_bonus:
		gestor_bonus.contar_muro_roto(global_position)
	queue_free()
