class_name RoofVisual
extends Node2D
## ظاهر پشت‌بام: بدنه‌ی آجری، نوار کف و تزئینات تصادفی (دودکش، منبع آب، آنتن، هواکش)

var roof_width := 800.0
var _decor: Array = []

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(absf(global_position.x)) * 7 + int(roof_width) * 13 + 1
	var count := rng.randi_range(1, 3)
	var kinds := ["chimney", "tank", "antenna", "vent"]
	for i in count:
		_decor.append({
			"kind": kinds[rng.randi_range(0, kinds.size() - 1)],
			"x": rng.randf_range(60, maxf(roof_width - 60, 61)),
		})

func _draw() -> void:
	var top := SegmentBuilder.GROUND_Y
	# بدنه‌ی آجری تیره
	draw_rect(Rect2(0, top, roof_width, SegmentBuilder.ROOF_DEPTH + 60), UiTheme.COLOR_BRICK_DARK)
	# درزهای آجر
	var mortar := Color(1, 1, 1, 0.05)
	var row := 0
	var y := top + 26.0
	while y < top + 320.0:
		draw_rect(Rect2(0, y, roof_width, 2), mortar)
		var off := 24.0 if row % 2 == 0 else 0.0
		var x := off
		while x < roof_width:
			draw_rect(Rect2(x, y, 2, 24), mortar)
			x += 48.0
		y += 26.0
		row += 1
	# نوار کف روشن‌تر + لبه‌ی کرم
	draw_rect(Rect2(0, top, roof_width, 14), UiTheme.COLOR_BRICK)
	draw_rect(Rect2(0, top, roof_width, 4), Color(0.91, 0.85, 0.72, 1.0))
	# لبه‌های کناری
	draw_rect(Rect2(0, top, 8, SegmentBuilder.ROOF_DEPTH + 60), UiTheme.COLOR_BRICK_DARK.darkened(0.3))
	draw_rect(Rect2(roof_width - 8, top, 8, SegmentBuilder.ROOF_DEPTH + 60), UiTheme.COLOR_BRICK_DARK.darkened(0.3))
	# تزئینات
	for d in _decor:
		_draw_decor(d["kind"], d["x"], top)

func _draw_decor(kind: String, x: float, top: float) -> void:
	match kind:
		"chimney":
			draw_rect(Rect2(x - 22, top - 64, 44, 64), UiTheme.COLOR_BRICK)
			draw_rect(Rect2(x - 26, top - 70, 52, 8), UiTheme.COLOR_BRICK_DARK)
		"tank":
			draw_rect(Rect2(x - 27, top - 58, 54, 58), UiTheme.COLOR_INDIGO)
			draw_rect(Rect2(x - 30, top - 64, 60, 8), UiTheme.COLOR_TEAL_DARK)
			draw_rect(Rect2(x - 8, top - 74, 16, 12), UiTheme.COLOR_INDIGO)
		"antenna":
			draw_rect(Rect2(x - 2, top - 86, 4, 86), UiTheme.COLOR_INK)
			draw_circle(Vector2(x, top - 88), 5.0, UiTheme.COLOR_INK)
			draw_circle(Vector2(x, top - 88), 2.4, UiTheme.COLOR_BRICK)
		"vent":
			draw_rect(Rect2(x - 17, top - 24, 34, 24), UiTheme.COLOR_TEAL_DARK)
			draw_rect(Rect2(x - 12, top - 19, 24, 4), UiTheme.COLOR_TEAL)
