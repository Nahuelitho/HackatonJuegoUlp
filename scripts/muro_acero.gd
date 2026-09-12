extends StaticBody2D
# Acero irrompible, solo con arma mejorada

func romper_muro(_es_de_jugador: bool, tiene_mejora: bool = false) -> void:
	if tiene_mejora:
		queue_free()
