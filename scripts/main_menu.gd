extends Control
## منوی اصلی: عنوان، شعار، رکورد، دکمه‌ها و پیش‌نمایش کاراکتر

@onready var title_label: Label = $Title
@onready var slogan_label: Label = $Slogan
@onready var best_label: Label = $BestScore
@onready var version_label: Label = $VersionLabel
@onready var start_button: Button = $Buttons/StartButton
@onready var characters_button: Button = $Buttons/CharactersButton
@onready var settings_button: Button = $Buttons/SettingsButton
@onready var char_visual: PlayerVisual = $CharVisual

var _t := 0.0

func _ready() -> void:
	UiTheme.apply(self)
	GameManager.change_state(GameManager.State.MENU)
	get_tree().paused = false
	AudioManager.play_bgm()
	title_label.text = "پرش خطرناک"
	UiTheme.style_title(title_label, 78)
	slogan_label.text = "یه پرش اشتباه، پایان بازی!"
	UiTheme.style_title(slogan_label, 30, Color(1.0, 0.93, 0.8, 0.95))
	best_label.text = "بهترین رکورد: " + UiTheme.fa_num(SaveManager.high_score)
	best_label.add_theme_color_override("font_color", Color(1.0, 0.96, 0.88, 0.85))
	best_label.add_theme_color_override("font_outline_color", UiTheme.COLOR_SKY_TOP)
	best_label.add_theme_constant_override("outline_size", 6)
	version_label.text = "نسخه ۱.۰.۰ — ساخته‌شده با Godot 4"
	version_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.45))
	version_label.add_theme_font_size_override("font_size", 18)
	start_button.text = "شروع بازی"
	characters_button.text = "شخصیت‌ها"
	characters_button.disabled = true
	characters_button.tooltip_text = "به‌زودی!"
	settings_button.text = "تنظیمات"
	start_button.pressed.connect(_on_start)
	settings_button.pressed.connect(_on_settings)
	_layout()

func _process(delta: float) -> void:
	_t += delta
	# شناوری آرام کاراکتر در منو
	char_visual.position.y = 522.0 + sin(_t * 2.0) * 5.0

func _draw() -> void:
	# سکوی پشت‌بام زیر کاراکتر
	draw_rect(Rect2(160, 520, 260, 220), UiTheme.COLOR_BRICK_DARK)
	draw_rect(Rect2(160, 520, 260, 14), UiTheme.COLOR_BRICK)
	draw_rect(Rect2(160, 520, 260, 4), Color(0.91, 0.85, 0.72, 1.0))

func _layout() -> void:
	title_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	title_label.offset_top = 84.0
	title_label.offset_bottom = 190.0
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	slogan_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	slogan_label.offset_top = 196.0
	slogan_label.offset_bottom = 250.0
	slogan_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	best_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	best_label.offset_top = 256.0
	best_label.offset_bottom = 298.0
	best_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var buttons: VBoxContainer = $Buttons
	buttons.set_anchors_preset(Control.PRESET_CENTER)
	buttons.grow_horizontal = Control.GROW_DIRECTION_BOTH
	buttons.grow_vertical = Control.GROW_DIRECTION_BOTH
	buttons.offset_top = 80.0
	buttons.offset_bottom = 80.0
	buttons.add_theme_constant_override("separation", 18)
	buttons.custom_minimum_size = Vector2(340, 0)
	version_label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	version_label.offset_top = -46.0
	version_label.offset_bottom = -14.0
	version_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _on_start() -> void:
	AudioManager.play("click", -6.0)
	GameManager.start_game()

func _on_settings() -> void:
	AudioManager.play("click", -6.0)
	GameManager.goto_settings()
