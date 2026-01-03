class_name Level
extends Node2D

var player:RigidBody2D
var checkpoint_start:Checkpoint
@onready var player_respawn_timer:Timer = $PlayerRespawnTimer
@onready var cam:Camera2D = $Camera2D
@onready var player_scene:PackedScene = preload("res://Scenes/rigid_player.tscn")
@onready var collectibles_parent:Node2D = $Collectibles
@onready var checkpoint_parent: Node2D = $Checkpoints
@onready var bg_color: ColorRect = $Bckgr/BgColor


func _ready() -> void:
	Global.all_collectibles = collectibles_parent.get_children()
	Global.set_max_coins()
	checkpoint_start = checkpoint_parent.get_node("CheckpointStart")
	assign_checkpoint_id()
	assign_collectible_id()
	set_level_color()

func assign_checkpoint_id():
	var checkpoint_arr:Array = get_all_checkpoints()
	checkpoint_start.id = -1
	for checkp in checkpoint_arr:
		checkp.id = checkpoint_arr.find(checkp)
		print("Chp ID: ", checkp.id)

func assign_collectible_id():
	var flag_arr:Array = get_all_flags()
	for flag in flag_arr:
		flag.id = flag_arr.find(flag)
		print("Flag ID: ", flag.id)

func get_all_checkpoints() -> Array:
	var all_checkpoints:Array = checkpoint_parent.get_children()
	introduce_yourself_to_checkpoints(all_checkpoints)
	all_checkpoints.erase(checkpoint_start)
	return all_checkpoints

func get_all_flags() -> Array:
	var all_flags:Array = []
	for collectible in Global.all_collectibles:
		if collectible.collectible_type == collectible.type.FLAG:
			all_flags.append(collectible)
	return all_flags

func set_level_color():
	if get_all_checkpoints().size() == get_all_flags().size():
		for i in get_all_checkpoints().size():
			var flag_color = ColorLib.pick_level_color()
			get_all_checkpoints()[i].modulate = flag_color
			get_all_flags()[i].modulate = flag_color

func introduce_yourself_to_checkpoints(all_checkpoints_including_start:Array):
	for checkpoint in all_checkpoints_including_start:
		checkpoint.level = self

func _process(_delta: float) -> void:
	glue_camera_to_player()

func glue_camera_to_player() -> void:
	if player != null and cam != null:
		cam.position = player.position

func start_respawn_timer() -> void:
	player_respawn_timer.start()

func _on_player_respawn_timer_timeout() -> void:
	add_new_player_instance()
	uncollect_collectibles()

func add_new_player_instance() -> void:
	var new_player:RigidBody2D = player_scene.instantiate()
	add_child(new_player)
	new_player.position = Global.last_checkpoint.position
	player = new_player

func uncollect_collectibles() -> void:
	for collectible in collectibles_parent.get_children():
		if Global.collected_before_checkpoint.has(collectible):
			collectible.uncollect()
	Global.collected_before_checkpoint.clear()
