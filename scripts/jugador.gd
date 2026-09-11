extends CharacterBody2D
# JugadorTanque Among Us - Battle City

@export var vida: int = 3
@export var velocidad: float = 200.0
@export var cadencia: float = 0.35
@export var esta_escondido: bool = false

@export var prefab_bala: PackedScene

@onready var punto_disparo: Marker2D = $PuntoDisparo
@onready var sprite: Sprite2D = $Sprite2D

var direccion_actual: Vector2 = Vector2.UP
var tiempo_proximo_disparo: float = 0.0

func _ready():
	pass

    func _physics_process(delta):
    	mover(delta)
        	if Input.is_action_pressed("disparar"):
            		disparar()

                    func mover(delta):
                    	# Fuerza 4 direcciones
                        	var entrada_x = Input.get_axis("mover_izq", "mover_der")
                            	var entrada_y = Input.get_axis("mover_arriba", "mover_abajo")
                                	
                                    	if abs(entrada_x) > abs(entrada_y):
                                        		entrada_y = 0
                                                	else:
                                                    		entrada_x = 0
                                                            	
                                                                	var entrada = Vector2(entrada_x, entrada_y)
                                                                    	
                                                                        	if entrada != Vector2.ZERO:
                                                                            		direccion_actual = entrada.normalized()
                                                                                    		rotation = direccion_actual.angle() + PI/2 # Rota tanque cabezon
                                                                                            	
                                                                                                	velocity = entrada * velocidad
                                                                                                    	move_and_slide()

                                                                                                        func disparar():
                                                                                                        	if Time.get_ticks_msec() / 1000.0 < tiempo_proximo_disparo:
                                                                                                            		return
                                                                                                                    	if not prefab_bala or not punto_disparo:
                                                                                                                        		return
                                                                                                                                	
                                                                                                                                    	tiempo_proximo_disparo = Time.get_ticks_msec() / 1000.0 + cadencia
                                                                                                                                        	
                                                                                                                                            	var bala = prefab_bala.instantiate()
                                                                                                                                                	bala.inicializar(direccion_actual, true) # true = es del jugador
                                                                                                                                                    	get_tree().current_scene.add_child(bala)
                                                                                                                                                        	bala.global_position = punto_disparo.global_position
                                                                                                                                                            	
                                                                                                                                                                	if esta_escondido:
                                                                                                                                                                    		cambiar_escondite(false)

                                                                                                                                                                            func cambiar_escondite(escondido: bool):
                                                                                                                                                                            	esta_escondido = escondido
                                                                                                                                                                                	sprite.modulate.a = 0.4 if escondido else 1.0

                                                                                                                                                                                    func recibir_danio(cantidad: int = 1):
                                                                                                                                                                                    	if esta_escondido:
                                                                                                                                                                                        		return # Inmune en pasto si no dispara
                                                                                                                                                                                                	vida -= cantidad
                                                                                                                                                                                                    	if vida <= 0:
                                                                                                                                                                                                        		get_node("/root/GestorJuego").jugador_murio()

                                                                                                                                                                                                                func aplicar_bonus(tipo: String):
                                                                                                                                                                                                                	match tipo:
                                                                                                                                                                                                                    		"vida_extra": vida += 1
                                                                                                                                                                                                                            		"escudo": cambiar_escondite(true) # Reusamos logica simple por ahora
                                                                                                                                                                                                                                    		_: pass