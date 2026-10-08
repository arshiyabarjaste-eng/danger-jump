extends Node2D
## سایه‌ی زیر پای کاراکتر برای تشخیص ارتفاع نسبت به سطح پشت‌بام

var ground_y := 560.0

func _process(_delta: float) -> void:
	var player := get_parent()
	if not (player is Node2D):
		return
	var pc := player as PlayerController
	if pc != null and pc.player_state == PlayerController.PlayerState.DEAD:
		visible = false
		return
	if player.global_position.y > ground_y + 30.0:
		visible = false  # در حال سقوط از حفره
		return
	visible = true
	var h: float = clampf(ground_y - player.global_position.y, 0.0, 400.0)
	var k: float = clampf(1.0 - h / 400.0, 0.25, 1.0)
	global_position = Vector2(player.global_position.x, ground_y + 6.0)
	scale = Vector2(k, k)
	modulate = Color(1, 1, 1, k * 0.8)

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.35))
	draw_circle(Vector2.ZERO, 26.0, Color(0, 0, 0, 0.30))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
