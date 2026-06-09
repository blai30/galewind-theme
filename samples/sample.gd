# GDScript sample for syntax highlighting
class_name Enemy
extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal died

enum State { IDLE, PATROL, CHASE, DEAD }

const MAX_HEALTH: int = 100
const SPEED: float = 180.0

@export var damage: int = 12
@export_range(0.0, 1.0) var aggression: float = 0.5
@export var patrol_points: Array[Vector2] = []

var _state: State = State.IDLE
var _health: int = MAX_HEALTH


func _ready() -> void:
	health_changed.connect(_on_health_changed)
	_state = State.PATROL


func take_damage(amount: int) -> void:
	_health = clampi(_health - amount, 0, MAX_HEALTH)
	health_changed.emit(_health, MAX_HEALTH)
	if _health == 0:
		_die()


func _physics_process(delta: float) -> void:
	match _state:
		State.PATROL:
			velocity = velocity.move_toward(Vector2.RIGHT * SPEED, delta * 600.0)
		State.CHASE:
			velocity = (get_target_position() - global_position).normalized() * SPEED
		_:
			velocity = Vector2.ZERO
	move_and_slide()


func get_target_position() -> Vector2:
	return patrol_points[0] if patrol_points.size() > 0 else global_position


func _die() -> void:
	_state = State.DEAD
	died.emit()
	queue_free()


func _on_health_changed(current: int, maximum: int) -> void:
	print("health: %d/%d" % [current, maximum])
