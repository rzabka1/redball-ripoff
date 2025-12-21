class_name Level
extends Node2D

var player:RigidBody2D
@onready var player_respawn_timer:Timer = $PlayerRespawnTimer
@onready var cam:Camera2D = $Camera2D
@onready var player_scene:PackedScene = preload("res://Scenes/rigid_player.tscn")
@onready var collectibles_parent:Node2D = $Collectibles

func _ready() -> void:
	Global.all_collectibles = collectibles_parent.get_children()
	Global.set_max_coins()

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
