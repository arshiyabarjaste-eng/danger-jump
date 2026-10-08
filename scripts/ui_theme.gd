class_name UiTheme
extends RefCounted
## تم مشترک رابط کاربری: پالت ایرانی، فونت فارسی وزیرمتن و راست‌به‌چپ‌سازی

const COLOR_SKY_TOP := Color("1c2a4a")      # نیلی شب
const COLOR_SKY_MID := Color("54487a")      # بنفش گرگ‌ومیش
const COLOR_SKY_HORIZON := Color("f2c98a")  # کرم گرم افق
const COLOR_TEAL := Color("1fa9a0")         # فیروزه‌ای
const COLOR_TEAL_DARK := Color("157a74")
const COLOR_CREAM := Color("fff6e5")        # کرم
const COLOR_BRICK := Color("c84b31")        # آجری
const COLOR_BRICK_DARK := Color("7e3220")
const COLOR_GREEN := Color("2e7d5b")        # سبز
const COLOR_INDIGO := Color("2b3a67")       # نیلی
const COLOR_INK := Color("242833")          # متن روی پنل کرم

static var _theme: Theme

static func get_font(bold: bool = false) -> Font:
	var path := "res://assets/fonts/Vazirmatn-%s.ttf" % ("Bold" if bold else "Regular")
	if ResourceLoader.exists(path):
		var f: Font = load(path)
		if f != null:
			return f
	# جایگزین: فونت سیستمی با پشتیبانی فارسی
	var sf := SystemFont.new()
	sf.font_names = PackedStringArray(["Vazirmatn", "Noto Naskh Arabic", "Noto Sans Arabic", "Roboto", "DejaVu Sans"])
	return sf

static func get_theme() -> Theme:
	if _theme != null:
		return _theme
	var t := Theme.new()
	t.default_font = get_font(false)
	t.default_font_size = 26
	# دکمه‌ها
	t.set_font("font", "Button", get_font(true))
	t.set_font_size("font_size", "Button", 30)
	t.set_color("font_color", "Button", COLOR_CREAM)
	t.set_color("font_hover_color", "Button", Color.WHITE)
	t.set_color("font_pressed_color", "Button", COLOR_CREAM)
	t.set_color("font_focus_color", "Button", COLOR_CREAM)
	t.set_color("font_disabled_color", "Button", Color(1, 1, 1, 0.45))
	t.set_stylebox("normal", "Button", _button_box(COLOR_TEAL))
	t.set_stylebox("hover", "Button", _button_box(COLOR_TEAL_DARK))
	t.set_stylebox("pressed", "Button", _button_box(COLOR_GREEN))
	t.set_stylebox("disabled", "Button", _button_box(Color(0.32, 0.36, 0.42, 0.6)))
	t.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	# برچسب‌ها
	t.set_color("font_color", "Label", COLOR_INK)
	# پنل‌ها
	t.set_stylebox("panel", "PanelContainer", _panel_box())
	_theme = t
	return t

static func _button_box(bg: Color) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.set_corner_radius_all(18)
	sb.content_margin_left = 34.0
	sb.content_margin_right = 34.0
	sb.content_margin_top = 12.0
	sb.content_margin_bottom = 14.0
	sb.shadow_color = Color(0, 0, 0, 0.25)
	sb.shadow_size = 6
	sb.shadow_offset = Vector2(0, 3)
	return sb

static func _panel_box() -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = COLOR_CREAM
	sb.set_corner_radius_all(24)
	sb.content_margin_left = 44.0
	sb.content_margin_right = 44.0
	sb.content_margin_top = 32.0
	sb.content_margin_bottom = 36.0
	sb.border_width_bottom = 6
	sb.border_color = COLOR_TEAL
	sb.shadow_color = Color(0, 0, 0, 0.35)
	sb.shadow_size = 14
	sb.shadow_offset = Vector2(0, 6)
	return sb

## اعمال تم و راست‌به‌چپ‌سازی کل درخت رابط
static func apply(root: Control) -> void:
	root.theme = get_theme()
	_apply_rtl_recursive(root)

static func _apply_rtl_recursive(node: Node) -> void:
	if node is Label:
		(node as Label).text_direction = Control.TEXT_DIRECTION_RTL
	elif node is Button:
		(node as Button).text_direction = Control.TEXT_DIRECTION_RTL
	elif node is CheckButton:
		(node as CheckButton).text_direction = Control.TEXT_DIRECTION_RTL
	elif node is LineEdit:
		(node as LineEdit).text_direction = Control.TEXT_DIRECTION_RTL
	for child in node.get_children():
		_apply_rtl_recursive(child)

## تبدیل ارقام لاتین به فارسی
static func fa_num(value: int) -> String:
	var digits := "۰۱۲۳۴۵۶۷۸۹"
	var out := ""
	for ch in str(value):
		if ch >= "0" and ch <= "9":
			out += digits[int(ch)]
		else:
			out += ch
	return out

## استایل تیترها
static func style_title(label: Label, size: int, color: Color = COLOR_CREAM, outline: Color = COLOR_SKY_TOP, outline_size: int = -1) -> void:
	label.add_theme_font_override("font", get_font(true))
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	if outline_size != 0:
		label.add_theme_color_override("font_outline_color", outline)
		label.add_theme_constant_override("outline_size", outline_size if outline_size > 0 else int(size / 7.0))

## رنگ متن دکمه‌های چک‌باکس روی پنل کرم
static func style_check_text(cb: CheckButton) -> void:
	cb.add_theme_color_override("font_color", COLOR_INK)
	cb.add_theme_color_override("font_hover_color", COLOR_INK)
	cb.add_theme_color_override("font_pressed_color", COLOR_INK)
	cb.add_theme_color_override("font_focus_color", COLOR_INK)
