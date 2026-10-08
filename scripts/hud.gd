class_name Hud
extends CanvasLayer
## رابط داخل بازی: امتیاز، رکورد، دکمه‌ی توقف و پوشش آماده‌باش

@onready var score_label: Label = $ScoreLabel
@onready var best_label: Label = $BestLabel
@onready var pause_button: Button = $PauseButton
@onready var ready_overlay: Control = $ReadyOverlay
@onready var ready_title: Label = $ReadyOverlay/Center/VB/ReadyTitle
@onready var ready_hint: Label = $ReadyOverlay/Center/VB/ReadyHint

func _ready() -> void:
	for c: Control in [score_label, best_label, ready_title, ready_hint, pause_button]:
		c.theme = UiTheme.get_theme()
		if c is Label:
			(c as Label).text_direction = Control.TEXT_DIRECTION_RTL
	# برچسب امتیاز
	score_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	score_label.offset_left = -560.0
	score_label.offset_right = -36.0
	score_label.offset_top = 20.0
	score_label.offset_bottom = 88.0
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	score_label.text = "۰"
	UiTheme.style_title(score_label, 46)
	# برچسب رکورد
	best_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	best_label.offset_left = -560.0
	best_label.offset_right = -36.0
	best_label.offset_top = 90.0
	best_label.offset_bottom = 128.0
	best_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	best_label.text = "رکورد: " + UiTheme.fa_num(SaveManager.high_score)
	best_label.add_theme_font_size_override("font_size", 24)
	best_label.add_theme_color_override("font_color", Color(1.0, 0.96, 0.88, 0.85))
	best_label.add_theme_color_override("font_outline_color", UiTheme.COLOR_SKY_TOP)
	best_label.add_theme_constant_override("outline_size", 6)
	# دکمه‌ی توقف — بزرگ و دور از مسیر شست دست تا لمس اشتباه پیش نیاید
	pause_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	pause_button.offset_left = 24.0
	pause_button.offset_right = 108.0
	pause_button.offset_top = 20.0
	pause_button.offset_bottom = 104.0
	pause_button.text = "II"
	pause_button.focus_mode = Control.FOCUS_NONE
	pause_button.visible = false
	pause_button.pressed.connect(_on_pause_pressed)
	# پوشش آماده‌باش
	ready_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	ready_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var center: CenterContainer = $ReadyOverlay/Center
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var vb: VBoxContainer = $ReadyOverlay/Center/VB
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 10)
	ready_title.text = "آماده؟"
	UiTheme.style_title(ready_title, 64)
	ready_hint.text = "لمس کن تا بدوی!"
	UiTheme.style_title(ready_hint, 30, Color(1.0, 0.96, 0.88, 0.9))
	var tw := create_tween().set_loops()
	tw.tween_property(ready_hint, "modulate:a", 0.35, 0.6).set_trans(Tween.TRANS_SINE)
	tw.tween_property(ready_hint, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)
	# اتصال‌ها
	ScoreManager.score_changed.connect(_on_score_changed)
	GameManager.state_changed.connect(_on_state_changed)

func _on_score_changed(score: int) -> void:
	score_label.text = UiTheme.fa_num(score)

func _on_state_changed(s: int) -> void:
	pause_button.visible = s == GameManager.State.PLAYING

func _on_pause_pressed() -> void:
	AudioManager.play("click", -6.0)
	GameManager.pause_game()

func hide_ready() -> void:
	ready_overlay.visible = false
