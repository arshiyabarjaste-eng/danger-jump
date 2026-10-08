class_name SegmentManager
extends Node2D
## تولید مسیر از قطعات از پیش طراحی‌شده، با پشتیبانی از Seed
## قطعات پشت دوربین آزاد می‌شوند و هرگز دو چالش خطرناک پشت‌سرهم نمی‌آید.

const SEG_FLAT := preload("res://scenes/segments/seg_flat.tscn")
const SEG_SPIKE := preload("res://scenes/segments/seg_spike.tscn")
const SEG_GAP := preload("res://scenes/segments/seg_gap.tscn")
const SEG_HIGH := preload("res://scenes/segments/seg_high.tscn")
const SEG_DOUBLE := preload("res://scenes/segments/seg_double.tscn")

@export var fixed_seed := ""  # برای بازتولید همان مسیر، در ادیتور مقدار بدهید

var _cursor := 0.0
var _rng := RandomNumberGenerator.new()
var _active: Array = []
var _forced_flat := 2
var _last_kind := ""
var _obstacle_manager: Node

func setup(seed_str: String) -> void:
	var s := seed_str
	if fixed_seed != "":
		s = fixed_seed
	if s == "":
		s = str(randi() % 1000000)
	_rng.seed = hash(s)
	print("[SegmentManager] seed = ", s)
	_cursor = 0.0
	_forced_flat = 2
	_last_kind = ""
	_obstacle_manager = get_parent().get_node_or_null("ObstacleManager")

func _physics_process(_delta: float) -> void:
	if not (GameManager.state in [GameManager.State.READY, GameManager.State.PLAYING]):
		return
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return
	var center := cam.get_screen_center_position().x
	while _cursor < center + 1100.0:
		_spawn_next()
	for seg in _active.duplicate():
		if is_instance_valid(seg) and seg.end_x() < center - 1000.0:
			seg.queue_free()
			_active.erase(seg)

func _spawn_next() -> void:
	var scene: PackedScene
	var kind := ""
	if _forced_flat > 0:
		scene = SEG_FLAT
		kind = "flat"
		_forced_flat -= 1
	else:
		kind = _pick_kind()
		scene = _scene_for(kind)
	var seg: SegmentBase = scene.instantiate()
	if seg.has_method("prepare"):
		seg.prepare(_rng, GameManager.run_speed)
	seg.position = Vector2(_cursor, 0)
	add_child(seg)
	_active.append(seg)
	if _obstacle_manager != null:
		_obstacle_manager.register_segment(seg)
	_cursor += seg.length_px
	_last_kind = kind

func _scene_for(kind: String) -> PackedScene:
	match kind:
		"spike": return SEG_SPIKE
		"gap": return SEG_GAP
		"high": return SEG_HIGH
		"double": return SEG_DOUBLE
		_: return SEG_FLAT

## انتخاب وزن‌دار نوع قطعه بر اساس پیشرفت مسیر (سختی تدریجی)
func _pick_kind() -> String:
	if GameManager.test_only_flat:
		return "flat"
	var kinds := ["flat", "spike", "high", "gap", "double"]
	var weights: Array = [30, 30, 20, 20, 0]
	if _cursor > 3200.0:
		weights = [22, 25, 15, 23, 15]
	var total := 0.0
	for w in weights:
		total += w
	var r := _rng.randf() * total
	var acc := 0.0
	for i in kinds.size():
		acc += weights[i]
		if r <= acc:
			var k: String = kinds[i]
			# ممنوعیت چالش‌های خطرناک پشت‌سرهم
			if k == _last_kind and (k == "gap" or k == "double"):
				k = "flat"
			return k
	return "flat"
