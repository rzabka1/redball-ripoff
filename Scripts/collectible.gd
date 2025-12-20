class_name Collectible
extends Area2D

enum type {COIN = 0, FLAG = 1}

@export var collectible_type:type = type.COIN
@onready var tileset_texture:CompressedTexture2D = preload("res://Assets/Sprites/black_white_sheet.png")

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	create_sprite(match_sprite_regions_to_type())
	create_collision()

func match_sprite_regions_to_type() -> Vector2:
	var region:Vector2
	match collectible_type:
		0:
			region = Vector2(0,64)
		1:
			region = Vector2(96,32)
		_:
			printerr("collectible.gd: Invalid collectible type!")
			breakpoint
	return region

func create_sprite(reg:Vector2) -> void:
	var sprite:Sprite2D = Sprite2D.new()
	set_up_sprite(sprite, Rect2(reg.x, reg.y, 32, 32))
	add_child(sprite)

func set_up_sprite(sprite, rect) -> void:
	sprite.texture = tileset_texture
	sprite.scale = Vector2(2.0, 2.0)
	sprite.region_enabled = true
	sprite.region_rect = rect

func create_collision() -> void:
	var collision_area:CollisionShape2D = CollisionShape2D.new()
	collision_area.shape = load("res://Resources/collectible_collision.tres")
	add_child(collision_area)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and body.has_method("die"):
		collect()

func collect() -> void:
	if collectible_type == 0:
		Global.collected_coins_count += 1
	elif collectible_type == 1:
		pass
	Global.collected_before_checkpoint.append(self)
	enable_disable(false)

func uncollect() -> void:
	if collectible_type == 0:
		Global.collected_coins_count -= 1
	elif collectible_type == 1:
		pass
	enable_disable(true)

func enable_disable(is_enabling:bool) -> void: # enabling if true, disabling if false
	for child in get_children():
		if child is Sprite2D:
			child.visible = is_enabling
	set_deferred("monitoring", is_enabling)
