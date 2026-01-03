class_name Checkpoint
extends Area2D

enum states {LOCKED = 0, UNLOCKED = 1}

var state:states:
	set(new_state):
		if new_state != state:
			state = new_state
			unlock()
var id:int
var level:Level
@onready var anim:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	state = states.LOCKED
	if name == "CheckpointStart":
		Global.last_checkpoint = self
		state = states.UNLOCKED

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if name == "CheckpointStart" or Global.last_flag_id >= id:
			state = states.UNLOCKED
		else: print("You must collect a flag!")

func unlock():
	anim.play("rise_flag")
	Global.last_checkpoint = self
	Global.collected_before_checkpoint.clear()
	change_bg_color()

func change_bg_color():
	await get_tree().create_timer(0.1).timeout
	level.bg_color.color = modulate.lightened(ColorLib.bg_lightened_value)
