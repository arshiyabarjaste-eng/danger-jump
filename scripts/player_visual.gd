class_name PlayerVisual
extends Node2D
## ظاهر کاراکتر «پرشو» با شکل‌های ساده + انیمیشن دویدن، پرش، فرود و شال‌گردن

var t := 0.0
var running := false
var dead := false
var _squash := Vector2.ONE

func _process(delta: float) -> void:
	t += delta
	if dead:
		queue_redraw()
		return
	if running:
		var bob := sin(t * 16.0)
		rotation = bob * 0.04
		position.y = absf(bob) * -3.0
	else:
		rotation = move_toward(rotation, 0.0, delta * 2.0)
		position.y = sin(t * 3.0) * -3.0  # شناوری آرام (منو / آماده‌باش)
	queue_redraw()

func _physics_process(delta: float) -> void:
	_squash = _squash.lerp(Vector2.ONE, minf(12.0 * delta, 1.0))
	scale = _squash

func stretch_jump() -> void:
	_squash = Vector2(0.82, 1.18)

func squash_land() -> void:
	_squash = Vector2(1.22, 0.78)

func _draw() -> void:
	var leg_phase := sin(t * 16.0) if running else 0.0
	# دم
	draw_arc(Vector2(-24, -30), 16.0, PI * 0.2, PI * 1.1, 12, UiTheme.COLOR_TEAL_DARK, 6.0, true)
	# پاها
	var leg_a := leg_phase * 7.0
	draw_circle(Vector2(-9 + leg_a, -8), 7.0, UiTheme.COLOR_TEAL_DARK)
	draw_circle(Vector2(9 - leg_a, -8), 7.0, UiTheme.COLOR_TEAL_DARK)
	# بدن و شکم
	draw_circle(Vector2(0, -32), 26.0, UiTheme.COLOR_TEAL)
	draw_circle(Vector2(4, -27), 15.0, UiTheme.COLOR_CREAM)
	# سر و گوش‌ها
	draw_circle(Vector2(3, -64), 20.0, UiTheme.COLOR_TEAL)
	draw_colored_polygon(PackedVector2Array([Vector2(-8, -78), Vector2(-2, -94), Vector2(4, -78)]), UiTheme.COLOR_TEAL)
	draw_colored_polygon(PackedVector2Array([Vector2(10, -78), Vector2(16, -92), Vector2(22, -76)]), UiTheme.COLOR_TEAL)
	# چشم‌ها، بینی
	draw_circle(Vector2(6, -66), 5.0, Color.WHITE)
	draw_circle(Vector2(16, -66), 5.0, Color.WHITE)
	draw_circle(Vector2(7.5, -66), 2.4, UiTheme.COLOR_INK)
	draw_circle(Vector2(17.5, -66), 2.4, UiTheme.COLOR_INK)
	draw_circle(Vector2(22, -60), 2.6, UiTheme.COLOR_BRICK)
	# شال‌گردن قرمز با دنباله‌ی مواج
	draw_rect(Rect2(-12, -48, 30, 9), UiTheme.COLOR_BRICK)
	var flap := sin(t * 9.0) * 5.0
	draw_colored_polygon(PackedVector2Array([Vector2(-12, -46), Vector2(-32, -42 + flap), Vector2(-12, -39)]), UiTheme.COLOR_BRICK)
