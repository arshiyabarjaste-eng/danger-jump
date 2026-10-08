extends Control
## صفحه‌ی تنظیمات: قطع/وصل صدا، بلندی صدا، بازنشانی و بازگشت — همه واقعی و ذخیره‌شونده

@onready var title_label: Label = $Title
@onready var sound_check: CheckButton = $Panel/VB/SoundCheck
@onready var volume_label: Label = $Panel/VB/VolumeLabel
@onready var volume_slider: HSlider = $Panel/VB/VolumeSlider
@onready var volume_value: Label = $Panel/VB/VolumeValue
@onready var reset_button: Button = $Panel/VB/ResetButton
@onready var back_button: Button = $Panel/VB/BackButton

func _ready() -> void:
	UiTheme.apply(self)
	title_label.text = "تنظیمات"
	UiTheme.style_title(title_label, 56)
	volume_slider.min_value = 0.0
	volume_slider.max_value = 1.0
	volume_slider.step = 0.05
	volume_slider.value = SaveManager.volume
	sound_check.button_pressed = not SaveManager.muted
	UiTheme.style_check_text(sound_check)
	sound_check.toggled.connect(_on_sound_toggled)
	volume_slider.value_changed.connect(_on_volume_changed)
	reset_button.pressed.connect(_on_reset)
	back_button.pressed.connect(_on_back)
	_layout()
	_refresh_texts()

func _layout() -> void:
	title_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	title_label.offset_top = 60.0
	title_label.offset_bottom = 150.0
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var panel: PanelContainer = $Panel
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var vb: VBoxContainer = $Panel/VB
	vb.add_theme_constant_override("separation", 20)
	volume_slider.custom_minimum_size = Vector2(420, 40)

func _refresh_texts() -> void:
	sound_check.text = "صدا: " + ("روشن" if not SaveManager.muted else "خاموش")
	volume_label.text = "بلندی صدا"
	volume_value.text = UiTheme.fa_num(int(round(SaveManager.volume * 100.0))) + "٪"
	reset_button.text = "بازنشانی تنظیمات"
	back_button.text = "بازگشت"

func _on_sound_toggled(on: bool) -> void:
	SaveManager.set_audio(not on, SaveManager.volume)
	AudioManager.apply_audio_settings()
	AudioManager.play("click", -6.0)
	_refresh_texts()

func _on_volume_changed(v: float) -> void:
	SaveManager.set_audio(SaveManager.muted, v)
	AudioManager.apply_audio_settings()
	volume_value.text = UiTheme.fa_num(int(round(v * 100.0))) + "٪"

func _on_reset() -> void:
	AudioManager.play("click", -6.0)
	SaveManager.set_audio(false, SaveManager.DEFAULT_VOLUME)
	AudioManager.apply_audio_settings()
	volume_slider.set_value_no_signal(SaveManager.volume)
	sound_check.set_pressed_no_signal(true)
	_refresh_texts()

func _on_back() -> void:
	AudioManager.play("click", -6.0)
	GameManager.goto_menu()
