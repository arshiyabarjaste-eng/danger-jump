extends Control
## صفحه‌ی پایان بازی: پیام، امتیاز، رکورد و دکمه‌های شروع مجدد / منو

@onready var dim: ColorRect = $Dim
@onready var panel: PanelContainer = $Panel
@onready var title_label: Label = $Panel/VB/Title
@onready var score_label: Label = $Panel/VB/ScoreLabel
@onready var best_label: Label = $Panel/VB/BestLabel
@onready var record_label: Label = $Panel/VB/RecordLabel
@onready var again_button: Button = $Panel/VB/AgainButton
@onready var menu_button: Button = $Panel/VB/MenuButton

func _ready() -> void:
	UiTheme.apply(self)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.07, 0.09, 0.15, 0.82)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var vb: VBoxContainer = $Panel/VB
	vb.add_theme_constant_override("separation", 16)
	title_label.text = "اوه! این یکی رو رد نکردی!"
	UiTheme.style_title(title_label, 40, UiTheme.COLOR_BRICK, Color(0, 0, 0, 0), 0)
	score_label.text = "امتیاز این دور: " + UiTheme.fa_num(GameManager.last_score)
	best_label.text = "بهترین رکورد: " + UiTheme.fa_num(SaveManager.high_score)
	record_label.text = "رکورد جدید!"
	record_label.visible = GameManager.last_is_record
	if GameManager.last_is_record:
		UiTheme.style_title(record_label, 34, UiTheme.COLOR_GREEN, Color(0, 0, 0, 0), 0)
		AudioManager.play("record", -2.0)
	again_button.text = "دوباره بازی کن"
	menu_button.text = "منوی اصلی"
	again_button.pressed.connect(_on_again)
	menu_button.pressed.connect(_on_menu)

func _on_again() -> void:
	AudioManager.play("click", -6.0)
	GameManager.start_game()

func _on_menu() -> void:
	AudioManager.play("click", -6.0)
	GameManager.goto_menu()
