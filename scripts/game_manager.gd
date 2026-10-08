extends Node
## مدیر بازی: ماشین وضعیت، سرعت و پیش‌رفت سختی
## وضعیت‌ها: منو / آماده / در حال بازی / توقف / در حال مرگ / پایان بازی

signal state_changed(new_state: State)
signal speed_changed(speed: float)

enum State { MENU, READY, PLAYING, PAUSED, DYING, GAME_OVER }

# --- پارامترهای قابل تنظیم گیم‌پلی ---
@export var initial_speed := 340.0      # سرعت اولیه‌ی دویدن (پیکسل بر ثانیه)
@export var max_speed := 640.0          # سقف سرعت
@export var acceleration := 7.5         # افزایش سرعت در هر ثانیه
@export var jump_gravity := 2400.0      # جاذبه‌ی پرش
@export var jump_velocity := -950.0     # نیروی پرش
@export var kill_y := 860.0             # عمق سقوط = مرگ

var state: int = State.MENU
var run_speed: float = 340.0
var run_time: float = 0.0
var run_seed: String = ""
var last_score: int = 0
var last_is_record: bool = false
var death_reason: String = ""
var test_only_flat: bool = false        # فقط برای تست خودکار: تولید قطعات تخت

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	reset_run()

func reset_run() -> void:
	run_speed = initial_speed
	run_time = 0.0
	last_score = 0
	last_is_record = false
	death_reason = ""
	if run_seed == "":
		run_seed = str(randi() % 1000000)

func change_state(s: int) -> void:
	if state == s:
		return
	state = s
	state_changed.emit(s)

func start_game() -> void:
	reset_run()
	ScoreManager.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/gameplay.tscn")
	change_state(State.READY)

func begin_running() -> void:
	if state == State.READY:
		change_state(State.PLAYING)

func pause_game() -> void:
	if state != State.PLAYING:
		return
	get_tree().paused = true
	change_state(State.PAUSED)

func resume_game() -> void:
	if state != State.PAUSED:
		return
	get_tree().paused = false
	change_state(State.PLAYING)

func player_died(reason: String) -> void:
	if state == State.DYING or state == State.GAME_OVER:
		return
	death_reason = reason
	change_state(State.DYING)

func finish_game_over() -> void:
	last_score = ScoreManager.score
	last_is_record = SaveManager.submit_score(last_score)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	change_state(State.GAME_OVER)

func goto_menu() -> void:
	get_tree().paused = false
	change_state(State.MENU)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func goto_settings() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _physics_process(delta: float) -> void:
	if state == State.PLAYING:
		run_time += delta
		run_speed = minf(initial_speed + acceleration * run_time, max_speed)
		speed_changed.emit(run_speed)
