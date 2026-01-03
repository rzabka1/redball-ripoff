extends Node

var current_color:Color
var bg_lightened_value:float = 0.3 #how much lighter background will be than the flag
# These below are actually *flag* colors
var level_colors:Array = [
	Color(0.743, 0.463, 0.778, 1.0),
	Color(0.99, 0.538, 0.663, 1.0),
	Color(1.0, 0.33, 0.531, 1.0),
	Color(0.89, 0.356, 0.356, 1.0),
	Color(0.933, 0.44, 0.342, 1.0),
	Color(0.63, 0.36, 0.214, 1.0),
	Color(0.75, 0.529, 0.36, 1.0),
	Color(0.87, 0.756, 0.444, 1.0),
	Color(0.643, 0.75, 0.292, 1.0),
	Color(0.557, 0.713, 0.406, 1.0),
	Color(0.384, 0.65, 0.45, 1.0),
	Color(0.099, 0.45, 0.351, 1.0),
	Color(0.239, 0.515, 0.57, 1.0),
	Color(0.338, 0.714, 0.72, 1.0),
	Color(0.544, 0.638, 0.8, 1.0)
	]

func pick_level_color() -> Color:
	var flag_color:Color
	var current_id:int = level_colors.find(current_color)
	var potential_colors:Array = []

	for color in level_colors:
		# Excluding similar colors
		if level_colors.find(color) != current_id and level_colors.find(color) != current_id-1 and level_colors.find(color) != current_id+1:
			potential_colors.append(color)
	flag_color = potential_colors.pick_random()
	current_color = flag_color
	
	return flag_color
