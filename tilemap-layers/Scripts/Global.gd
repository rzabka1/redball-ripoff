extends Node

@onready var coins_count_label: Label = get_tree().root.get_node("Main/HUD/Control/Panel/CoinsCountLabel")

var max_coins:int = 0

var collected_before_checkpoint = []
@onready var last_checkpoint = get_tree().root.get_node("Main/Gameplay").get_child(0).get_node("CheckpointStart")

var collected_coins_count:int:
	set(new_val):
		if new_val != collected_coins_count:
			collected_coins_count = new_val
			update_label()

func set_max_coins():
	var collectibles = get_tree().root.get_node("Main/Gameplay").get_child(0).get_node("Collectibles")
	for child in collectibles.get_children():
		if child.collectible_type == 0:
			max_coins += 1
			update_label()


func update_coin_count(_new_collected_coins_count):
	update_label()

func update_label():
	coins_count_label.text = str(collected_coins_count) + " / " + str(max_coins)
