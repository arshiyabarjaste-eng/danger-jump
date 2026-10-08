extends Node2D
## کنترل اصلی صحنه‌ی گیم‌پلی: اتصال اجزا، شروع با اولین لمس، توقف و مرگ

@onready var player: PlayerController = $Player
@onready var camera: GameCamera = $GameCamera
@onready var segment_manager: SegmentManager = $World/SegmentManager
@onready var hud: Hud = $HUD

func _ready() -> void:
	get_tree().paused = false
	GameManager.reset_run()
	ScoreManager.reset()
	ScoreManager.begin_tracking(player)
	segment_manager.setup(GameManager.run_seed)
	player.died.connect(_on_player_died)
	GameManager.change_state(GameManager.State.READY)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and GameManager.state == GameManager.State.READY:
		# اولین لمس فقط شروع دویدن است تا پرش اشتباه اتفاق نیفتد
		GameManager.begin_running()
		player.start_running()
		hud.hide_ready()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("pause") and GameManager.state == GameManager.State.PLAYING:
		_toggle_pause()

func _toggle_pause() -> void:
	if GameManager.state == GameManager.State.PLAYING:
		GameManager.pause_game()
	elif GameManager.state == GameManager.State.PAUSED:
		GameManager.resume_game()

func _on_player_died() -> void:
	camera.shake(16.0)
