extends Node
# Cuenta muros y spawnea bonus cada 3-7

@export var prefab_bonus: Array[PackedScene] # vida y escudo

var muros_rotos: int = 0
var proximo_objetivo: int = 0

func _ready() -> void:
	add_to_group("gestor_bonus")
	randomize()
	sortear_proximo_objetivo()

func sortear_proximo_objetivo() -> void:
	proximo_objetivo = randi_range(3, 7)
	muros_rotos = 0

func contar_muro_roto(posicion: Vector2) -> void:
	muros_rotos += 1
	if muros_rotos >= proximo_objetivo:
		spawnear_bonus.call_deferred(posicion)
		sortear_proximo_objetivo()

func spawnear_bonus(pos: Vector2) -> void:
	if prefab_bonus.is_empty():
		return
	var tipo_random = randi() % prefab_bonus.size()
	var bonus = prefab_bonus[tipo_random].instantiate()
	get_tree().current_scene.add_child(bonus)
	bonus.global_position = pos
