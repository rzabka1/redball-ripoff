extends RigidBody2D

@onready var raycast: RayCast2D = $RayCast2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var angle
var jump_velocity:int = -40000

func _physics_process(_delta: float) -> void:
	var direction:float = Input.get_axis("Left", "Right")
	if direction:
		var speed:int = 500
		if angle != null and abs(angle) < 75:
			if direction < 0:
				speed += angle * 30
			elif direction > 0:
				speed -= angle * 30
		else:
			speed = speed / 2
		apply_central_force(Vector2(direction*speed,0))
	if Input.is_action_just_pressed("Jump") and angle != null and abs(angle) < 75:
			apply_central_force(Vector2(0, jump_velocity))
	raycast.rotation = -rotation + deg_to_rad(90)


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var _contacted:Array = get_colliding_bodies()
	if _contacted.size() > 0:
		if _state.get_contact_count() > 1:
			var closer_to_zero:float = 180 # this has to be HIGHER than any potential angle to surface. Highest observed angle: 110
			for i in _state.get_contact_count():
				var pos:Vector2 = _state.get_contact_collider_position(i)
				var one_of_angles:float = rad_to_deg(raycast.get_angle_to(pos))
				print("one of: ",one_of_angles)
				if abs(closer_to_zero) > abs(one_of_angles): # e.g. if 180 > 45
					closer_to_zero = one_of_angles # choosing between lower number of the two angles this for-loop returns. Theres always two "one_of_angles" and closest_to_zero is being set to the lower one.
			print("closest: ",closer_to_zero)
			angle = closer_to_zero
		else:
			if _state.get_contact_count() > 0: #the stuff below only applies if player is on floor (avoiding "out of bounds" errors in debugger)
				var pos:Vector2 = _state.get_contact_collider_position(0)
				angle = rad_to_deg(raycast.get_angle_to(pos))
	else:
		angle = null
		
		
func _on_spike_detecting_area_body_entered(_body: Node2D) -> void:
	die()


func die():
	print("died")
	collision.set_deferred("disabled", true)
	sprite.visible = false
	for i in 10:
		var particle:Node = load("res://Scenes/rigid_particles.tscn").instantiate()
		var new_particle_parent:Node2D = Node2D.new()
		get_parent().add_child(new_particle_parent)
		new_particle_parent.position = position
		new_particle_parent.call_deferred("add_child", particle)
		particle.position.x = randf_range(0,6)
		particle.position.y = randf_range(-6,0)
	get_parent().start_respawn_timer()
	queue_free()
