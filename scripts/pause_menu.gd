class_name PauseMenu
extends CanvasLayer
## منوی توقف: دنیای بازی کاملاً منجمد می‌شود (حرکت، تولید مسیر و امتیاز)

@onready var dim: ColorRect = $Dim
@onready var panel: PanelContainer = $Panel
@onready var pause_title: Label = $Panel/VB/PauseTitle
@onready var resume_button: Button = $Panel/VB/ResumeButton
@onready var restart_button: Button = $Panel/VB/RestartButton
@onready var mute_check: CheckButton = $Panel/VB/MuteCheck
@onready var menu_button: Button = $Panel/VB/MenuButton

func _ready() -> void:
	visible = false
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.08, 0.1, 0.16, 0.6)
	panel.theme = UiTheme.get_theme()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var vb: VBoxContainer = $Panel/VB
	vb.add_theme_constant_override("separation", 18)
	pause_title.text = "بازی متوقف شد"
	UiTheme.style_title(pause_title, 40, UiTheme.COLOR_BRICK, Color(0, 0, 0, 0), 0)
	resume_button.text = "ادامه"
	restart_button.text = "شروع دوباره"
	menu_button.text = "منوی اصلی"
	_refresh_mute()
	UiTheme.style_check_text(mute_check)
	resume_button.pressed.connect(_on_resume)
	restart_button.pressed.connect(_on_restart)
	menu_button.pressed.connect(_on_menu)
	mute_check.toggled.connect(_on_mute_toggled)
	GameManager.state_changed.connect(_on_state_changed)

func _unhandled_input(event: InputEvent) -> void:
	# کلید Escape هنگام توقف، بازی را ادامه می‌دهد
	if event.is_action_pressed("pause") and GameManager.state == GameManager.State.PAUSED:
		_on_resume()

func _on_resume() -> void:
	AudioManager.play("click", -6.0)
	GameManager.resume_game()

func _on_restart() -> void:
	AudioManager.play("click", -6.0)
	get_tree().paused = false
	GameManager.start_game()

func _on_menu() -> void:
	AudioManager.play("click", -6.0)
	get_tree().paused = false
	GameManager.goto_menu()

func _on_mute_toggled(on: bool) -> void:
	SaveManager.set_audio(not on, SaveManager.volume)
	AudioManager.apply_audio_settings()
	AudioManager.play("click", -6.0)
	_refresh_mute()

func _refresh_mute() -> void:
	mute_check.button_pressed = not SaveManager.muted
	mute_check.text = "صدا: " + ("روشن" if not SaveManager.muted else "خاموش")

func _on_state_changed(s: int) -> void:
	visible = s == GameManager.State.PAUSED
