extends Node

var points = 0
var player_name = "player"

###########################################################################
# ADDITIONAL FUNCTIONS

func player():
	for x in get_tree().get_nodes_in_group("player"):
		return x

func time(sec):
	var timer = Timer.new()
	timer.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().get_root().add_child(timer) #to process
	timer.set_wait_time(sec) # Set Timer's delay to "sec" seconds
	timer.start() # Start the Timer counting down
	return timer

func delete_actor(relate):
	save_load.current_data.erase([level_root().filename, relate.name])
	relate.queue_free()

func teleport_actor(relate, map, pos_ID):
	if save_load.current_data.has([level_root().filename, relate.name]):
		var old = (save_load.current_data[[level_root().filename, relate.name]]).duplicate()
		save_load.current_data[[map, relate.name]] = old
		save_load.current_data[[map, relate.name]]["next_pos_ID"] = pos_ID
		save_load.current_data.erase([level_root().filename, relate.name])
		relate.queue_free()

func change_level(map, pos_ID):
	teleport_actor(player(), map, pos_ID)
	yield(time(0.01), "timeout")
	get_tree().change_scene(map)

func level_root():
	for x in get_tree().get_nodes_in_group("level_root"):
		return x

func main():
	return level_root().get_node("main")

func get_position_2D(ID):
	for x in get_tree().get_nodes_in_group("pos"):
		if x.name == ID:
			return x
