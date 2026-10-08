class_name GameCamera
extends Camera2D
## دوربین: دنبال‌کردن کاراکتر با نگاه رو به جلو + لرزش کوتاه اختیاری

var _shake := 0.0

func _ready() -> void:
	position_smoothing_enabled = false

func _physics_process(delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player is Node2D and GameManager.state != GameManager.State.GAME_OVER:
		global_position = Vector2(player.global_position.x + 150.0, 360.0)
	if _shake > 0.0:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _shake
		_shake = maxf(_shake - 60.0 * delta, 0.0)
	else:
		offset = Vector2.ZERO

func shake(strength: float) -> void:
	_shake = strength
