extends StaticBody2D
# El acero interior puede romperse con mejora; el borde nunca se rompe.

@export var rompible: bool = true

func romper_muro(_es_de_jugador: bool, impacto_fuerte: bool = false) -> void:
	if rompible and impacto_fuerte:
		queue_free()
