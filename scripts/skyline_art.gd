class_name SkylineArt
extends Node2D
## سیلوئت لایه‌های شهر: ۱=ابنیه‌ی دور، ۲=گنبد و مناره، ۳=پشت‌بام‌های همسایه

var variant := 1
var art_width := 2560.0

func _draw() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = variant * 101
	match variant:
		1:
			_far(rng)
		2:
			_mid(rng)
		3:
			_near(rng)

func _dome(center: Vector2, r: float, color: Color) -> void:
	var pts := PackedVector2Array()
	for i in 13:
		var a := PI - PI * i / 12.0
		pts.append(center + Vector2(cos(a) * r, -sin(a) * r * 0.85))
	pts.append(center + Vector2(r, 2))
	pts.append(center + Vector2(-r, 2))
	draw_colored_polygon(pts, color)

func _far(rng: RandomNumberGenerator) -> void:
	var color := Color("3a4a7a")
	var base_y := 512.0
	var x := 0.0
	while x < art_width:
		var w := rng.randf_range(70, 180)
		var h := rng.randf_range(40, 150)
		draw_rect(Rect2(x, base_y - h, w, h + 200), color)
		if rng.randf() < 0.35:
			_dome(Vector2(x + w * 0.5, base_y - h), minf(w * 0.45, 34.0), color)
		x += w + rng.randf_range(10, 50)

func _mid(rng: RandomNumberGenerator) -> void:
	var color := Color("2b3a67")
	var base_y := 545.0
	var x := 40.0
	while x < art_width:
		if rng.randf() < 0.3:
			# بنای گنبددار با دو مناره
			var w := rng.randf_range(140, 240)
			var h := rng.randf_range(70, 110)
			draw_rect(Rect2(x, base_y - h, w, h + 220), color)
			_dome(Vector2(x + w * 0.5, base_y - h), w * 0.32, color)
			for mx in [x - 18.0, x + w + 18.0]:
				draw_rect(Rect2(mx - 7, base_y - h - 90, 14, h + 90), color)
				draw_circle(Vector2(mx, base_y - h - 92), 9.0, color)
			x += w + rng.randf_range(60, 140)
		else:
			var w2 := rng.randf_range(90, 200)
			var h2 := rng.randf_range(30, 80)
			draw_rect(Rect2(x, base_y - h2, w2, h2 + 220), color)
			x += w2 + rng.randf_range(30, 90)

func _near(rng: RandomNumberGenerator) -> void:
	var color := Color("232f52")
	var base_y := 585.0
	var x := 0.0
	while x < art_width:
		var w := rng.randf_range(160, 320)
		var h := rng.randf_range(50, 110)
		draw_rect(Rect2(x, base_y - h, w, h + 240), color)
		# دیش و منبع آب
		if rng.randf() < 0.5:
			draw_arc(Vector2(x + rng.randf_range(30, w - 30), base_y - h - 12), 16.0, PI, 2 * PI, 12, color, 5.0, true)
		if rng.randf() < 0.5:
			var tx := x + rng.randf_range(30, w - 40)
			draw_rect(Rect2(tx, base_y - h - 34, 34, 34), color)
		# پنجره‌های روشن
		var win_count := int(w / 55.0)
		for i in win_count:
			if rng.randf() < 0.4:
				draw_rect(Rect2(x + 18 + i * 55, base_y - h + 18, 12, 16), Color(1.0, 0.9, 0.65, 0.75))
		x += w + rng.randf_range(20, 70)
