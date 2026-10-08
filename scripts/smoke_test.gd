extends Node
## آزمون دود خودکار (E2E) — اجرا: godot --headless -- --smoke-test
## سناریو: منو → شروع → دویدن → پرش → ممنوعیت پرش دوم → توقف/ادامه →
## ساخت همه‌ی قطعات → مرگ با مانع → صفحه‌ی پایان → ری‌استارت کامل → ذخیره‌سازی

var _failures: Array[String] = []
var _count := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not _enabled():
		return
	print("=== Danger Jump Smoke Tests ===")
	_run_all()

func _enabled() -> bool:
	return "--smoke-test" in OS.get_cmdline_user_args()

func _run_all() -> void:
	await _frames(10)
	GameManager.run_seed = "smoke-seed"
	GameManager.test_only_flat = true
	# ۱) منوی اصلی
	_check("menu_loads", get_tree().current_scene != null and get_tree().current_scene.name == "MainMenu")
	# ۲) شروع بازی
	GameManager.start_game()
	await _frames(15)
	_check("gameplay_loads", get_tree().current_scene.name == "Gameplay")
	_check("state_ready", GameManager.state == GameManager.State.READY)
	var player: PlayerController = get_tree().get_first_node_in_group("player")
	_check("player_exists", player != null)
	if player == null:
		_finish()
		return
	# ۳) اولین لمس: شروع دویدن بدون پرش
	_tap_jump()
	await _frames(5)
	_check("first_tap_starts", GameManager.state == GameManager.State.PLAYING)
	_check("first_tap_no_jump", player.velocity.y >= -1.0)
	# ۴) دویدن و امتیاز
	var x0 := player.global_position.x
	await _frames(90)
	_check("player_runs", player.global_position.x > x0 + 250.0)
	_check("score_increases", ScoreManager.score > 0)
	_check("segments_spawn", get_tree().get_nodes_in_group("roofs").size() >= 3)
	# ۵) پرش
	var y0 := player.global_position.y
	_tap_jump()
	await _frames(6)
	_check("jump_works", player.velocity.y < -400.0 and player.global_position.y < y0 - 20.0)
	# ۶) ممنوعیت پرش دوم در هوا
	var vy_now := player.velocity.y
	_tap_jump()
	await _frames(3)
	_check("no_double_jump", player.velocity.y >= vy_now + 10.0)
	await _frames(80)
	# ۷) توقف و ادامه
	GameManager.pause_game()
	await _frames(2)
	_check("pause_freezes", get_tree().paused and GameManager.state == GameManager.State.PAUSED)
	GameManager.resume_game()
	await _frames(2)
	_check("resume_works", not get_tree().paused and GameManager.state == GameManager.State.PLAYING)
	# ۸) ساخت همه‌ی قطعات از پیش طراحی‌شده
	var ok_segments := true
	var seg_paths := [
		"res://scenes/segments/seg_flat.tscn",
		"res://scenes/segments/seg_spike.tscn",
		"res://scenes/segments/seg_gap.tscn",
		"res://scenes/segments/seg_high.tscn",
		"res://scenes/segments/seg_double.tscn",
	]
	for path in seg_paths:
		var seg: Node2D = (load(path) as PackedScene).instantiate()
		get_tree().current_scene.add_child(seg)
		await _frames(2)
		var roof_count := 0
		for child in seg.get_children():
			if child is StaticBody2D:
				roof_count += 1
		if roof_count < 1 or seg.length_px <= 0:
			ok_segments = false
			print("   segment problem: ", path)
		seg.queue_free()
		await _frames(1)
	_check("segments_build", ok_segments)
	# ۹) مرگ با برخورد به مانع
	var spike: Node2D = (load("res://scenes/obstacles/spike.tscn") as PackedScene).instantiate()
	spike.position = Vector2(player.global_position.x + 60.0, 560.0)
	get_tree().current_scene.get_node("World").add_child(spike)
	await _frames(20)
	_check("hit_causes_death", GameManager.state == GameManager.State.DYING or GameManager.state == GameManager.State.GAME_OVER)
	await _frames(80)
	_check("game_over_scene", get_tree().current_scene.name == "GameOver")
	_check("score_recorded", GameManager.last_score >= 0 and SaveManager.high_score >= GameManager.last_score)
	# ۱۰) ری‌استارت کامل
	GameManager.start_game()
	await _frames(15)
	player = get_tree().get_first_node_in_group("player")
	var restart_ok := GameManager.state == GameManager.State.READY \
		and ScoreManager.score == 0 \
		and absf(GameManager.run_speed - GameManager.initial_speed) < 0.01 \
		and not get_tree().paused \
		and get_tree().get_nodes_in_group("obstacles").is_empty()
	_check("restart_resets", restart_ok)
	# ۱۱) ذخیره‌ی تنظیمات
	SaveManager.set_audio(true, 0.5)
	SaveManager.load_data()
	_check("settings_persist", SaveManager.muted and absf(SaveManager.volume - 0.5) < 0.001)
	SaveManager.set_audio(false, 0.8)
	# ۱۲) عدالت حفره (ریاضی)
	var air_time := 2.0 * absf(GameManager.jump_velocity) / GameManager.jump_gravity
	var seg_gap: Node2D = (load("res://scenes/segments/seg_gap.tscn") as PackedScene).instantiate()
	var max_gap := GameManager.initial_speed * air_time * 0.7
	_check("gap_fair", seg_gap.gap_width <= max_gap)
	seg_gap.free()
	# ۱۳) صداها
	_check("audio_streams", AudioManager.stream_count() >= 6)
	# پاک‌سازی رکورد تست
	SaveManager.reset_all()
	_finish()

func _tap_jump() -> void:
	var ev := InputEventAction.new()
	ev.action = "jump"
	ev.pressed = true
	Input.parse_input_event(ev)
	var ev2 := InputEventAction.new()
	ev2.action = "jump"
	ev2.pressed = false
	Input.parse_input_event(ev2)

func _frames(n: int) -> void:
	for i in n:
		await get_tree().physics_frame

func _check(test_name: String, cond: bool) -> void:
	_count += 1
	if cond:
		print("PASS: ", test_name)
	else:
		_failures.append(test_name)
		print("FAIL: ", test_name)

func _finish() -> void:
	print("=== %d/%d passed ===" % [_count - _failures.size(), _count])
	if _failures.is_empty():
		print("ALL TESTS PASSED")
		get_tree().quit(0)
	else:
		print("FAILED: ", ", ".join(_failures))
		get_tree().quit(1)
