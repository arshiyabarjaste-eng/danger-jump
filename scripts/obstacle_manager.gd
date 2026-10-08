class_name ObstacleManager
extends Node
## پیگیری موانع فعال و گزارش عبور برای امتیاز و صدا

var _registered := {}

func reset() -> void:
	_registered.clear()

func register_segment(seg: Node) -> void:
	for child in seg.find_children("*", "Area2D", true, false):
		if child is Obstacle and not _registered.has(child.get_instance_id()):
			_registered[child.get_instance_id()] = true
			(child as Obstacle).obstacle_passed.connect(_on_obstacle_passed)

func _on_obstacle_passed(_obstacle: Obstacle) -> void:
	ScoreManager.register_obstacle_passed()
	AudioManager.play("pass", -8.0, randf_range(0.98, 1.06))
