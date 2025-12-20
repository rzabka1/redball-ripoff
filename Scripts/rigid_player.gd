extends RigidBody2D

var angle # cannot assign type, cause sometimes this has to be a float value, and sometimes null.
var jump_velocity:int = -40000

@onready var raycast:RayCast2D = $RayCast2D
@onready var collision:CollisionShape2D = $CollisionShape2D
@onready var sprite:Sprite2D = $Sprite2D

func _ready() -> void:
	introduce_yourself_to_level()

func introduce_yourself_to_level():
	if get_parent().get_script().resource_path.ends_with("level.gd"):
		get_parent().player = self
	else:
		printerr("rigid_player.gd: Invalid player-to-Level path. Check the tree or level script name!")
		breakpoint

func _physics_process(_delta: float) -> void:
	handle_movement()
	handle_jump()
	raycast.rotation = -rotation + deg_to_rad(90)

func handle_movement() -> void:
	var direction:float = Input.get_axis("Left", "Right")
	var speed:float = 500
	if direction:
		if angle != null and abs(angle) < 75:
			if direction < 0:
				speed += angle * 30
			elif direction > 0:
				speed -= angle * 30
		else:
			speed /= 2
		apply_central_force(Vector2(direction*speed,0))

func handle_jump() -> void:
	if Input.is_action_just_pressed("Jump") and angle != null and abs(angle) < 75:
			apply_central_force(Vector2(0, jump_velocity))

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var _contacted:Array = get_colliding_bodies()
	if _contacted.size() > 0:
		handle_angle_to_surface_relation(_state)
	else:
		angle = null

func handle_angle_to_surface_relation(_state: PhysicsDirectBodyState2D) -> void:
	if _state.get_contact_count() > 1:
		var closer_to_zero:float = 180 # this has to be HIGHER than any potential angle to surface. Highest observed angle: 110
		for i in _state.get_contact_count():
			var pos:Vector2 = _state.get_contact_collider_position(i)
			var one_of_angles:float = rad_to_deg(raycast.get_angle_to(pos))
			if abs(closer_to_zero) > abs(one_of_angles): # e.g. if 180 > 45
				closer_to_zero = one_of_angles # choosing between lower number of the two angles this for-loop returns. Theres always two "one_of_angles" and closest_to_zero is being set to the lower one.
		angle = closer_to_zero
	else:
		if _state.get_contact_count() == 1: #the stuff below only applies if player is on floor (avoiding "out of bounds" errors in debugger)
			var pos:Vector2 = _state.get_contact_collider_position(0)
			angle = rad_to_deg(raycast.get_angle_to(pos))

func _on_spike_detecting_area_body_entered(_body: Node2D) -> void:
	die()

func die() -> void:
	collision.set_deferred("disabled", true)
	sprite.visible = false
	set_up_particles()
	get_parent().start_respawn_timer()
	queue_free()

func set_up_particles():
	var new_particle_parent:Node2D = Node2D.new()
	get_parent().add_child(new_particle_parent)
	new_particle_parent.position = position
	create_particles(new_particle_parent)

func create_particles(parent):
	var particle_count:int = 10
	for i in particle_count:
		var particle:Node = load("res://Scenes/rigid_particles.tscn").instantiate()
		parent.call_deferred("add_child", particle)
		particle.position.x = randf_range(0,6)
		particle.position.y = randf_range(-6,0)
