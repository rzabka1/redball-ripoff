class_name Checkpoint
extends Area2D

enum states {LOCKED = 0, UNLOCKED = 1}

var state:states:
	set(new_state):
		if new_state != state:
			state = new_state
			unlock()
@onready var anim:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	state = states.LOCKED
	if name == "CheckpointStart":
		Global.last_checkpoint = self

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		state = states.UNLOCKED

func unlock():
	anim.play("rise_flag")
	Global.last_checkpoint = self
	Global.collected_before_checkpoint.clear()
