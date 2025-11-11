class_name Collectible
extends Area2D

@onready var tileset_texture = preload("res://Assets/Sprites/black_white_sheet.png")


enum type {COIN = 0, CLOUD = 1}
@export var collectible_type = type.COIN


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
	var coin_tex = Sprite2D.new()
	set_up_sprite(coin_tex, Rect2(0, 64, 32, 32))
	var cloud_tex = Sprite2D.new()
	set_up_sprite(cloud_tex, Rect2(64, 64, 32, 32))
	
	create_collision()
	
	match collectible_type:
		0:
			add_child(coin_tex)
		1:
			add_child(cloud_tex)
		_:
			return

func set_up_sprite(sprite, rect):
	sprite.texture = tileset_texture
	sprite.scale = Vector2(2.0, 2.0)
	sprite.region_enabled = true
	sprite.region_rect = rect

func create_collision():
	var collision_area = CollisionShape2D.new()
	collision_area.shape = load("res://Resources/collectible_collision.tres")
	add_child(collision_area)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and body.has_method("die"):
		collect()

func collect():
	print("collect")
	if collectible_type == 0:
		Global.collected_coins_count += 1
	elif collectible_type == 1:
		print("cloud collected")
	Global.collected_before_checkpoint.append(self)
	disable()

func uncollect():
	print("uncollect")
	if collectible_type == 0:
		Global.collected_coins_count -= 1
	elif collectible_type == 1:
		print("cloud UNcollected")
	enable()

func disable():
	print("disable")
	for child in get_children():
		if child is Sprite2D:
			child.visible = false
	set_deferred("monitoring", false)

func enable():
	print("enable")
	for child in get_children():
		if child is Sprite2D:
			child.visible = true
	set_deferred("monitoring", true)
