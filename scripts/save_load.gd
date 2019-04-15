
###########################################################################################
# CODE BY RADMATT @rdmtt/radmtt
# Credit me if you change, use or share it.
###########################################################################################

###########################################################################################
# This is a prototype, there might be some bugs and limitations but it is, in my opinion, the correct way
# of saving complicated games with multiple levels.
# Please improve on it if you can and share it with the community.

# SEE GITHUB REPSOITORY FOR MORE INFO - https://github.com/rdmtt/Godot-3.1-Advanced-Save-System
###########################################################################################

extends "res://scripts/globals.gd"

# not working properly
#var paths = ["user://slot_1.save", "user://slot_2.save", "user://slot_3.save"]

var last_saved_slot = 0

var slots = {
	"slot_1":{},
	"slot_2":{},
	"slot_3":{},
}

# UPDATED REGULARLY
var current_data = {
}

# UPDATED AT MAP'S _READY
var map_data = {
}

var visited_maps = []

func reset_data():
	current_data = {}
	map_data = {}
	visited_maps = []

func update_current_data():
	if level_root() != null:

		for x in get_tree().get_nodes_in_group("persist"):
			var actor_data = []

			# save fixed variables (in func save_node())
			actor_data = save_node(x).duplicate()

			# save custom variables
			if x.has_method("save_this"):
				var dict = x.save_this()
				for y in dict:
					actor_data[y] = dict[y]

			# stich save data together
			current_data[[level_root().get_filename(), x.name]] = actor_data

		current_data["last_map"] = level_root().get_filename()
		current_data["visited_maps"] = visited_maps.duplicate()

		current_data["date"] = {"second": OS.get_time()["second"], "minute": OS.get_time()["minute"], "hour" : OS.get_time()["hour"], "day": OS.get_date()["day"], "month" : OS.get_date()["month"], "year" : OS.get_date()["year"]}

		current_data["last_saved_slot"] = last_saved_slot


		# SAVING GLOBAL VALUES
		current_data["globals"] = {}
		var arr = ["points", "player_name"]

		for x in arr:
			current_data["globals"][x] = G.get(x)


func update_map_data():
	if level_root() != null:

		for x in get_tree().get_nodes_in_group("persist"):
			var actor_data = []

			# save fixed variables (in func save_node())
			actor_data = save_node(x).duplicate()

			# save custom variables
			if x.has_method("save_this"):
				var dict = x.save_this()
				for y in dict:
					actor_data[y] = dict[y]

			# stich save data together
			map_data[[level_root().get_filename(), x.name]] = actor_data




func load_map():
	#	data structure ---- [[map_filename, node_name], node]
	update_map_data()

	var persist_nodes = get_tree().get_nodes_in_group("persist")

	var keys_in_map = []
	for node in persist_nodes:
		keys_in_map.append([[level_root().filename, node.name], node])


	if visited_maps.has(level_root().filename):
		# DELETE OBJECTS
		for x in keys_in_map:
			if !(current_data.has(x[0])):
				x[1].queue_free()
	else:
		visited_maps.append(level_root().filename)

	# ADD OBJECTS
	for x in current_data:
		if x[0] == level_root().filename and !(map_data.has(x)):
			var obj = load(current_data[x]["file"]).instance()
			obj.name = current_data[x]["name"]
			level_root().get_node("main").add_child(obj)

	# UPDATE OBJECTS
	yield(time(0.01), "timeout")
	for node in get_tree().get_nodes_in_group("persist"):
		update_node(node)




func update_node(node):
	if current_data.has([level_root().filename, node.name]):
		var data = current_data[[level_root().filename, node.name]]

		if data.has("next_pos_ID"):
			if data["next_pos_ID"] != "":
				var pos = get_position_2D(data["next_pos_ID"]).global_position
				node.global_position = pos
				current_data[[level_root().filename, node.name]]["next_pos_ID"] = ""
				node.next_pos_ID = ""
			else:
				node.global_position = Vector2(data["pos"][0], data["pos"][1])
		else:
			node.global_position = Vector2(data["pos"][0], data["pos"][1])

		for x in data:
			if x == "scale":
				node.scale = Vector2(data["scale"][0], data["scale"][1])
			else:
				node.set(x, data[x])



# IMPORTANT! THIS IS WHERE YOU DECLARE VALUES TO BE SAVED!
func save_node(node):
	var all = {}

	if node is Node2D:
		all.parent = node.get_parent().get_path()
		all.file = node.get_filename()
		all.name = node.get_name()
		all.groups = node.get_groups()
		all.pos = [node.get_global_position().x, node.get_global_position().y]
		all.rotation_degrees = node.get_rotation_degrees()
		all.scale = [node.get_scale().x, node.get_scale().y]

	if node is RigidBody2D:
		all.mode = node.mode
		all.mass = node.mass
		all.weight = node.weight
		all.gravity_scale = node.gravity_scale
		all.linear_velocity = node.linear_velocity
		all.linear_damp = node.linear_damp
		all.angular_velocity = node.angular_velocity
		all.angular_damp = node.angular_damp


	return all



func save_to_slot(slot_name):
	update_current_data()
	if slots.has(slot_name):
		slots[slot_name] = current_data.duplicate()
#		print("SAVED")
	else:
		print("THIS SLOT DOESN'T EXIST")


func load_from_slot(slot_name):

	current_data = slots[slot_name].duplicate()
	visited_maps = slots[slot_name]["visited_maps"].duplicate()
	last_saved_slot = slots[slot_name]["last_saved_slot"]

	for x in slots[slot_name]["globals"].keys():
		G.set(x, slots[slot_name]["globals"][x])

	yield(time(0.01), "timeout")
	get_tree().change_scene(slots[slot_name]["last_map"])


# EXPORTING TO FILES NOT WORKING PROPERLY

#func save_to_file(slot):
#	save_to_slot("slot_"+str(slot))
#	yield(time(0.1), "timeout")
#	var save_game = File.new()
#	save_game.open(paths[slot+1], File.WRITE)
#	save_game.store_line(to_json(current_data.duplicate()))
##	print(save_game.get_as_text())
#	save_game.close()


#func load_from_file(slot):
#	var save_game = File.new()
#	save_game.open(paths[slot+1], File.READ)
#	var data = parse_json(save_game.get_as_text())
##	var data = parse_json(save_game.get_line())
#	yield(time(0.01), "timeout")
#	slots["slot_"+str(slot)] = data
#	save_game.close()
#
#	yield(time(0.01), "timeout")
#
#	load_from_slot("slot_"+str(slot))

