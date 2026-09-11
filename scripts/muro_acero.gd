extends StaticBody2D
# Acero irrompible, solo con arma mejorada

var es_indestructible: bool = true

func romper_muro(es_de_jugador: bool, tiene_mejora: bool = false):
	if tiene_mejora:
    		queue_free() # Solo si viene con power-up