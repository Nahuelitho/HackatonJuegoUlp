@tool
extends Node2D

func _ready() -> void:
	visible = Engine.is_editor_hint()
