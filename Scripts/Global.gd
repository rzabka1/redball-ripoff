extends Node

var max_coins:int = 0
var collected_before_checkpoint = []
var collected_coins_count:int:
	set(new_val):
		if new_val != collected_coins_count:
			collected_coins_count = new_val
			update_label()
var all_collectibles:Array = []
var last_checkpoint:Area2D
@onready var coins_count_label:Label = get_tree().root.get_node("Main/HUD/Control/Panel/CoinsCountLabel")

func set_max_coins() -> void:
	for collectible in all_collectibles:
		if collectible.collectible_type == 0:
			max_coins += 1
			update_label()

func update_label() -> void:
	coins_count_label.text = str(collected_coins_count) + " / " + str(max_coins)
