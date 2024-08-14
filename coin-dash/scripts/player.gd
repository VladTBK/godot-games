extends CharacterBody2D

signal pickup
signal hurt
@export var speed: int = 250
var screensize: Vector2 = Vector2(480, 720)
var animated_sprite: AnimatedSprite2D


func _ready() -> void:
	animated_sprite = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += _delta * speed * velocity
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	animation_change()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("coins"):
		_area.get_parent().pickup()
		pickup.emit()
	if _area.is_in_group("obstacles"):
		hurt.emit()
		die()


func animation_change() -> void:
	if velocity.length() > 0:
		animated_sprite.animation = "run"
	else:
		animated_sprite.animation = "idle"

	animated_sprite.flip_h = velocity.x < 0


func start() -> void:
	animated_sprite.animation = "run"
	position = 0.5 * screensize


func die() -> void:
	animated_sprite.animation = "hurt"
