extends CharacterBody2D

class_name Player

@export var sync_velocity = Vector2.ZERO

const speed = 400
const friction = .05

const col_force = 10

func _enter_tree():
	$Label.text = name
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.is_multiplayer_authority():
		var dir = Input.get_vector("left", "right", "up", "down").normalized()
		velocity = velocity + (dir * speed * delta)
		velocity.x = lerp(velocity.x, 0.0, friction)
		velocity.y = lerp(velocity.y, 0.0, friction)
		sync_velocity = velocity
	else:
		velocity = sync_velocity
	move_and_slide()
	
	for index in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(index)
		var collider: RigidBody2D = collision.get_collider()
		if (collider.get_class() == "RigidBody2D"):
			var col_force_vec = -collision.get_normal() * col_force # rotate the force along collision normal
			# collision pos
			# > RigidBody.add_force(force, pos) > The position uses the rotation of the global coordinate system, but is centered at the object's origin.
			# > KinematicCollision.position() > The point of collision, in global coordinates.
			# So to add force at collision position, substract colliders pos from collision.position
			var col_pos = collision.get_position() - collider.transform.origin
			collider.apply_force(col_force_vec, col_pos)

