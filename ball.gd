extends RigidBody2D

@export var sync_velocity = Vector2.ZERO
@export var sync_name = "?"

@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var label: Label = $Label

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(1)
	$Label.text = sync_name

func _ready():
	if sync.is_multiplayer_authority():
		sync_name = str(randi_range(0, 100))
	label.text = sync_name

func _process(delta):	
	queue_redraw()

func _physics_process(delta):
	label.text = sync_name
	if sync.is_multiplayer_authority():
		# TODO: why is is assigning sync_name every tick required for other clients to get it?
		sync_name = label.text
		sync_velocity = linear_velocity
	else:
		linear_velocity = sync_velocity
	pass

func _draw():
	draw_circle(Vector2.ZERO, 10, Color.GREEN)

