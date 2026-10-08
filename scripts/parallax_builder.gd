class_name ParallaxBuilder
extends ParallaxBackground
## ساخت پس‌زمینه‌ی چندلایه‌ی پارالاکس در زمان اجرا
## لایه‌ها: آسمان ثابت، شهر دور، گنبد و مناره، پشت‌بام‌های نزدیک

const SKY_W := 2560.0

func _ready() -> void:
	layer = -100
	_build_sky()
	_build_layer(0.15, 1)
	_build_layer(0.35, 2)
	_build_layer(0.6, 3)

func _build_sky() -> void:
	var layer := ParallaxLayer.new()
	layer.motion_scale = Vector2.ZERO
	layer.add_child(SkyArt.new())
	add_child(layer)

func _build_layer(scale_x: float, variant: int) -> void:
	var layer := ParallaxLayer.new()
	layer.motion_scale = Vector2(scale_x, 1.0)
	layer.motion_mirroring = Vector2(SKY_W, 0)
	var art := SkylineArt.new()
	art.variant = variant
	art.art_width = SKY_W
	layer.add_child(art)
	add_child(layer)
