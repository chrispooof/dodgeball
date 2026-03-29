extends Area2D

signal hit

@onready var sprite = $AnimatedSprite2D
@onready var collisions = {
	"LeftRightWalk": [
		$CollisionPolygon2DLeftRight0,
		$CollisionPolygon2DLeftRight1
	],
	"UpDownWalk": [
		$CollisionPolygon2DUpDown0,
		$CollisionPolygon2DUpDown1
	]
}

@export var SPEED = 9000.0
var screen_size: Vector2
var velocity = Vector2.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size
	sprite.frame_changed.connect(_on_frame_changed)

func _on_frame_changed() -> void:
	for animation in collisions.values():
		for shape in animation:
			shape.disabled = true
	
	var animation_name = sprite.animation
	var frame = sprite.frame
	
	if collisions.has(animation_name):
		var shapes = collisions[animation_name]
		
		if frame < shapes.size():
			shapes[frame].disabled = false

func _on_body_entered(_body):
	hide() 
	hit.emit()

func start(pos):
	position = pos
	show()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction := Input.get_axis("ui_left", "ui_right")
	if x_direction:
		velocity.x = x_direction * SPEED * delta
	else:
		velocity.x = 0

	var y_direction := Input.get_axis("ui_up", "ui_down")
	if y_direction:
		velocity.y = y_direction * SPEED * delta
	else:
		velocity.y = 0

	position += velocity * delta

func _process(delta: float) -> void:
	# Clamp the player's position to the screen bounds
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.y > 0 or velocity.y < 0:
		sprite.play("UpDownWalk")
	elif velocity.x > 0 or velocity.x < 0:
		sprite.play("LeftRightWalk")
	else:
		sprite.stop()
