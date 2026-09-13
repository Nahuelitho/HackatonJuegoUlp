@tool
extends Node2D

func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var arena := Rect2(320, 40, 640, 640)
	draw_rect(arena, Color(0.01, 0.015, 0.025, 0.65), true)
	for x in range(320, 961, 48):
		draw_line(Vector2(x, 40), Vector2(x, 680), Color(0.2, 0.7, 0.9, 0.14), 1.0)
	for y in range(40, 681, 48):
		draw_line(Vector2(320, y), Vector2(960, y), Color(0.2, 0.7, 0.9, 0.14), 1.0)

	_marcar(Vector2(350, 84), "ENEMIGO", Color(1.0, 0.25, 0.2, 0.9))
	_marcar(Vector2(641, 84), "JEFE / ENEMIGO", Color(1.0, 0.08, 0.03, 0.9))
	_marcar(Vector2(930, 84), "ENEMIGO", Color(1.0, 0.25, 0.2, 0.9))
	_marcar(Vector2(399, 601), "JUGADOR", Color(1.0, 0.76, 0.16, 0.9))
	_marcar(Vector2(641, 630), "BASE", Color(1.0, 0.8, 0.15, 0.9))

func _marcar(posicion: Vector2, texto: String, color: Color) -> void:
	draw_circle(posicion, 10.0, color, false, 2.0)
	draw_string(ThemeDB.fallback_font, posicion + Vector2(14, 5), texto, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, color)
