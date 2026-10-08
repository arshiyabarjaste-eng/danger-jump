class_name Obstacle
extends Area2D
## پایه‌ی موانع: تشخیص برخورد = مرگ، و گزارش عبور موفق برای امتیاز
## kind = 0 → تیغ زمینی، kind = 1 → کولر آبی (مانع بلند)

signal obstacle_passed(obstacle: Obstacle)

@export var kind := 0

var passed := false

func _ready() -> void:
	add_to_group("obstacles")
	collision_layer = 0
	collision_mask = 2  # فقط کاراکتر
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	if passed:
		return
	if GameManager.state != GameManager.State.PLAYING:
		return
	var player := get_tree().get_first_node_in_group("player")
	if player is Node2D and player.global_position.x > global_position.x + 40.0:
		passed = true
		obstacle_passed.emit(self)

func _on_body_entered(body: Node) -> void:
	if body is PlayerController and GameManager.state == GameManager.State.PLAYING:
		(body as PlayerController).die("hit")

func _draw() -> void:
	if kind == 0:
		# تیغ سه‌گوش
		draw_colored_polygon(PackedVector2Array([Vector2(-26, 0), Vector2(26, 0), Vector2(0, -46)]), UiTheme.COLOR_BRICK)
		draw_colored_polygon(PackedVector2Array([Vector2(-12, 0), Vector2(12, 0), Vector2(0, -28)]), UiTheme.COLOR_BRICK_DARK)
		draw_rect(Rect2(-30, -4, 60, 6), UiTheme.COLOR_BRICK_DARK)
	else:
		# کولر آبی ایرانی
		var box := Rect2(-55, -64, 110, 64)
		draw_rect(box, UiTheme.COLOR_TEAL_DARK)
		draw_rect(box.grow(-4.0), UiTheme.COLOR_TEAL)
		for i in 5:
			draw_rect(Rect2(-48, -56 + i * 11, 96, 5), UiTheme.COLOR_TEAL_DARK.darkened(0.25))
		draw_rect(Rect2(-55, -72, 110, 8), UiTheme.COLOR_CREAM)
