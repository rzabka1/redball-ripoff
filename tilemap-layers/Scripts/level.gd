extends Node2D

@onready var player_respawn_timer = $PlayerRespawnTimer
@onready var cam = $Camera2D
@onready var player_scene = preload("res://Scenes/rigid_player.tscn")


func _ready() -> void:
	Global.set_max_coins()

func _process(_delta: float) -> void:
	var player
	for child in get_children():
		if child is RigidBody2D:
			player = child
	if player != null and cam != null:
		cam.position = player.position

func start_respawn_timer():
	$PlayerRespawnTimer.start()

func _on_player_respawn_timer_timeout() -> void:
	var new_player = player_scene.instantiate()
	add_child(new_player)
	new_player.position = Global.last_checkpoint.position
	uncollect_collectibles()

func uncollect_collectibles():
	print(Global.collected_before_checkpoint)
	for collectible in $Collectibles.get_children():
		if Global.collected_before_checkpoint.has(collectible):
			collectible.uncollect()
	Global.collected_before_checkpoint.clear()
