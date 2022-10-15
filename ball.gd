extends RigidBody2D

@export var sync_velocity = Vector2.ZERO

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(1)
	pass

func _process(delta):
	queue_redraw()

func _physics_process(delta):	
	if $MultiplayerSynchronizer.is_multiplayer_authority():
		sync_velocity = linear_velocity
	else:
		linear_velocity = sync_velocity

func _draw():
	draw_circle(Vector2.ZERO, 10, Color.GREEN)

	
