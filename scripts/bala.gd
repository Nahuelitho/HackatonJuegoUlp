extends Area2D
# Bala Among Us

@export var velocidad: float = 400.0
var direccion: Vector2 = Vector2.UP
var es_de_jugador: bool = true

func inicializar(dir: Vector2, de_jugador: bool):
	direccion = dir
    	es_de_jugador = de_jugador
        	rotation = dir.angle() + PI/2

            func _physics_process(delta):
            	global_position += direccion * velocidad * delta

                func _on_body_entered(cuerpo):
                	if cuerpo.has_method("romper_muro"):
                    		cuerpo.romper_muro(es_de_jugador)
                            	if cuerpo.has_method("recibir_danio"):
                                		cuerpo.recibir_danio(1)
                                        	queue_free()

                                            func _on_area_entered(area):
                                            	if area.has_method("romper_muro"):
                                                		area.romper_muro(es_de_jugador)
                                                        	queue_free()