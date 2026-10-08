class_name SkyArt
extends Node2D
## آسمان گرگ‌ومیش تهران: گرادیان نیلی به کرم + ستاره‌ها + خورشید نزدیک افق

func _draw() -> void:
	# گرادیان دو مرحله‌ای آسمان
	var top := PackedVector2Array([Vector2(-400, -500), Vector2(3600, -500), Vector2(3600, 330), Vector2(-400, 330)])
	var top_cols := PackedColorArray([UiTheme.COLOR_SKY_TOP, UiTheme.COLOR_SKY_TOP, UiTheme.COLOR_SKY_MID, UiTheme.COLOR_SKY_MID])
	draw_polygon(top, top_cols)
	var bottom := PackedVector2Array([Vector2(-400, 330), Vector2(3600, 330), Vector2(3600, 1200), Vector2(-400, 1200)])
	var bottom_cols := PackedColorArray([UiTheme.COLOR_SKY_MID, UiTheme.COLOR_SKY_MID, UiTheme.COLOR_SKY_HORIZON, UiTheme.COLOR_SKY_HORIZON])
	draw_polygon(bottom, bottom_cols)
	# ستاره‌ها
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 60:
		var p := Vector2(rng.randf_range(0, 2560), rng.randf_range(-100, 300))
		var a := rng.randf_range(0.2, 0.8)
		draw_circle(p, rng.randf_range(1.0, 2.6), Color(1.0, 0.96, 0.88, a))
	# خورشید گرم
	draw_circle(Vector2(1980, 220), 120.0, Color(1.0, 0.85, 0.62, 0.22))
	draw_circle(Vector2(1980, 220), 86.0, Color(1.0, 0.85, 0.62, 0.95))
