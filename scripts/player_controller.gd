class_name PlayerController
extends CharacterBody2D
## کنترل کاراکتر: دویدن خودکار به راست، پرش تک‌ضرب لمسی، مرگ و انیمیشن

signal jumped
signal landed
signal died

enum PlayerState { IDLE, RUNNING, DEAD }

var player_state: int = PlayerState.IDLE

@onready var visual: PlayerVisual = $Visual
@onready var shadow: Node2D = $Shadow
@onready var dust: CPUParticles2D = $Dust
@onready var collision: CollisionShape2D = $Collision

func _ready() -> void:
        add_to_group("player")
        collision_layer = 2   # لایه‌ی کاراکتر (موانع فقط همین را می‌بینند)
        collision_mask = 1    # برخورد با سکوها
        _setup_dust()
        visual.running = false

func start_running() -> void:
        if player_state == PlayerState.IDLE:
                player_state = PlayerState.RUNNING
                visual.running = true

func _physics_process(delta: float) -> void:
        match player_state:
                PlayerState.DEAD:
                        _dead_physics(delta)
                        return
                PlayerState.IDLE:
                        velocity.x = 0.0
                        if not is_on_floor():
                                velocity.y += GameManager.jump_gravity * delta
                PlayerState.RUNNING:
                        velocity.x = GameManager.run_speed
                        if not is_on_floor():
                                velocity.y += GameManager.jump_gravity * delta
        var was_on_floor := is_on_floor()
        move_and_slide()
        if player_state == PlayerState.RUNNING:
                if is_on_floor() and not was_on_floor:
                        _on_landed()
                if global_position.y > GameManager.kill_y:
                        die("fall")

## پرش فقط از روی زمین؛ پرش دوم در هوا ممنوع است
func try_jump() -> void:
        if player_state != PlayerState.RUNNING:
                return
        if not is_on_floor():
                return
        velocity.y = GameManager.jump_velocity
        visual.stretch_jump()
        AudioManager.play("jump", -6.0, randf_range(0.95, 1.08))
        jumped.emit()

func _unhandled_input(event: InputEvent) -> void:
        if event.is_action_pressed("jump"):
                try_jump()

func _on_landed() -> void:
        visual.squash_land()
        dust.restart()
        AudioManager.play("land", -10.0, randf_range(0.9, 1.05))
        landed.emit()

func die(reason: String) -> void:
        if player_state == PlayerState.DEAD:
                return
        player_state = PlayerState.DEAD
        visual.dead = true
        visual.running = false
        if reason == "hit":
                velocity = Vector2(-140.0, -680.0)
        # در سقوط از حفره، سرعت فعلی حفظ می‌شود
        AudioManager.play("hit", -2.0)
        died.emit()
        GameManager.player_died(reason)
        _finish_death()

func _dead_physics(delta: float) -> void:
        velocity.y += GameManager.jump_gravity * delta
        velocity.x = move_toward(velocity.x, 0.0, 300.0 * delta)
        global_position += velocity * delta  # بدون برخورد؛ سقوط آزاد
        visual.rotation += 7.0 * delta

func _finish_death() -> void:
        await get_tree().create_timer(1.0).timeout
        if not is_inside_tree():
                return
        GameManager.finish_game_over()

func _setup_dust() -> void:
        dust.emitting = false
        dust.one_shot = true
        dust.amount = 14
        dust.lifetime = 0.45
        dust.explosiveness = 0.9
        dust.direction = Vector2(0, -1)
        dust.spread = 70.0
        dust.gravity = Vector2(0, 260)
        dust.initial_velocity_min = 60.0
        dust.initial_velocity_max = 160.0
        dust.scale_amount_min = 3.0
        dust.scale_amount_max = 7.0
        dust.color = Color(0.93, 0.87, 0.76, 0.85)
