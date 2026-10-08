extends Node
## امتیازدهی: بر پایه‌ی مسافت واقعی + جایزه‌ی ثابت برای هر مانع عبورشده
## امتیاز هر فریم اضافه نمی‌شود؛ فقط وقتی مقدار صحیح عوض شود سیگنال می‌فرستد.

signal score_changed(score: int)

const PX_PER_METER := 60.0
const DISTANCE_POINTS_PER_METER := 10.0
const OBSTACLE_BONUS := 50

var score: int = 0
var obstacles_passed: int = 0
var _start_x: float = 0.0
var _player: Node2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	reset()

func reset() -> void:
	score = 0
	obstacles_passed = 0
	_player = null
	score_changed.emit(0)

func begin_tracking(player: Node2D) -> void:
	_player = player
	_start_x = player.global_position.x

func register_obstacle_passed() -> void:
	obstacles_passed += 1

func _physics_process(_delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		return
	if _player == null:
		return
	var meters: float = maxf(_player.global_position.x - _start_x, 0.0) / PX_PER_METER
	var new_score := int(meters * DISTANCE_POINTS_PER_METER) + obstacles_passed * OBSTACLE_BONUS
	if new_score != score:
		score = new_score
		score_changed.emit(score)
