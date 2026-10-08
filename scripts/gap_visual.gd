class_name GapDeco
extends Node2D
## تزئین لبه‌های شکسته‌ی حفره + عمق‌نمایی تاریک درون حفره

var left_x := 350.0
var gap_w := 160.0

func _draw() -> void:
	var top := SegmentBuilder.GROUND_Y
	var x1 := left_x
	var x2 := left_x + gap_w
	# گرادیان تاریک به داخل حفره
	var pts := PackedVector2Array([Vector2(x1, top), Vector2(x2, top), Vector2(x2, top + 280), Vector2(x1, top + 280)])
	var cols := PackedColorArray([Color(0.1, 0.08, 0.1, 0.5), Color(0.1, 0.08, 0.1, 0.5), Color(0.1, 0.08, 0.1, 0.05), Color(0.1, 0.08, 0.1, 0.05)])
	draw_polygon(pts, cols)
	# آجرهای آویزان از لبه‌ها
	draw_rect(Rect2(x1 - 6, top, 6, 26), UiTheme.COLOR_BRICK_DARK.darkened(0.35))
	draw_rect(Rect2(x1 + 2, top + 30, 10, 7), UiTheme.COLOR_BRICK.darkened(0.25))
	draw_rect(Rect2(x1 + 4, top + 44, 7, 6), UiTheme.COLOR_BRICK.darkened(0.35))
	draw_rect(Rect2(x2, top, 6, 22), UiTheme.COLOR_BRICK_DARK.darkened(0.35))
	draw_rect(Rect2(x2 - 12, top + 27, 10, 7), UiTheme.COLOR_BRICK.darkened(0.25))
	# ترک روی سطح
	draw_rect(Rect2(x1 - 40, top + 2, 34, 3), UiTheme.COLOR_BRICK_DARK.darkened(0.4))
	draw_rect(Rect2(x2 + 8, top + 2, 30, 3), UiTheme.COLOR_BRICK_DARK.darkened(0.4))
