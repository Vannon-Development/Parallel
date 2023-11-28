class_name Player extends CharacterBody2D

@export var walk_speed: float

enum Direction { UP, DOWN, LEFT, RIGHT }

const _direction_vector: Array[Vector2] = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)]
@onready var _idle_frames: Array[Sprite2D] = [$"Visual/Back Idle", $"Visual/Front Idle", $"Visual/Left Idle", $"Visual/Right Idle"]
@onready var _walk_frames: Array[AnimatedSprite2D] = [$"Visual/Back Walk", $"Visual/Front Walk", $"Visual/Left Walk", $"Visual/Right Walk"]

var _facing: Direction = Direction.DOWN
var _motion: Vector2

func _process(_delta):
	var input := Input.get_vector("Left", "Right", "Up", "Down")
	_update_motion(input)
	_update_facing(input)
	_update_frame()

func _physics_process(_delta):
	velocity = _motion * walk_speed
	move_and_slide()

func _update_frame():
	for index in _idle_frames.size():
		_idle_frames[index].visible = _motion.is_zero_approx() and int(_facing) == index
	for index in _walk_frames.size():
		_walk_frames[index].visible = not _motion.is_zero_approx() and int(_facing) == index

func _update_motion(input: Vector2):
	_motion = input

func _update_facing(input: Vector2):
	if not input.is_zero_approx():
		var fac: int = _facing
		var dot: float = -2
		for index in _direction_vector.size():
			var d := _direction_vector[index].dot(input)
			if d > dot:
				dot = d
				fac = index
		_facing = fac as Direction
