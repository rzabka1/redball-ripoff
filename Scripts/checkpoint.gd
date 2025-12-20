class_name Checkpoint
extends Area2D

enum states {LOCKED = 0, UNLOCKED = 1}

@export var state:states:
	set(new_state):
		if new_state != state:
			state = new_state
			unlock()
@onready var anim:AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and body.has_method("die"):
		state = states.UNLOCKED

func unlock():
	anim.play("rise_flag")
	Global.last_checkpoint = self
	Global.collected_before_checkpoint.clear()
