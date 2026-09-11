extends Area2D
# Pasto alto que esconde - estilo Battle City

func _on_body_entered(cuerpo):
	if cuerpo.has_method("cambiar_escondite"):
    		cuerpo.cambiar_escondite(true)

            func _on_body_exited(cuerpo):
            	if cuerpo.has_method("cambiar_escondite"):
                		cuerpo.cambiar_escondite(false)