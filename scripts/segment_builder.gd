class_name SegmentBuilder
extends RefCounted
## سازنده‌ی اجزای مشترک قطعات: سکوی پشت‌بام، موانع و تزئینات

const GROUND_Y := 560.0
const ROOF_DEPTH := 380.0

static func add_roof(parent: Node2D, x: float, w: float) -> void:
	if w <= 4.0:
		return
	var body := StaticBody2D.new()
	body.name = "Roof"
	body.position = Vector2(x, 0)
	body.add_to_group("roofs")
	var col := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(w, ROOF_DEPTH)
	col.shape = shape
	col.position = Vector2(w * 0.5, GROUND_Y + ROOF_DEPTH * 0.5)
	body.add_child(col)
	var vis := RoofVisual.new()
	vis.roof_width = w
	body.add_child(vis)
	parent.add_child(body)

static func add_spike(parent: Node2D, x: float) -> void:
	var spike: Node2D = preload("res://scenes/obstacles/spike.tscn").instantiate()
	spike.position = Vector2(x, GROUND_Y)
	parent.add_child(spike)

static func add_ac(parent: Node2D, x: float) -> void:
	var ac: Node2D = preload("res://scenes/obstacles/high_obstacle.tscn").instantiate()
	ac.position = Vector2(x, GROUND_Y)
	parent.add_child(ac)

static func add_gap_deco(parent: Node2D, left_edge_x: float, gap_w: float) -> void:
	var deco := GapDeco.new()
	deco.left_x = left_edge_x
	deco.gap_w = gap_w
	parent.add_child(deco)
