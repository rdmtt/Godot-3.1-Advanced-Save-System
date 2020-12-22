extends Button

export (int, 1, 3) var slot = 1
export (String, "SAVE", "LOAD") var type = "SAVE"

func _ready():
	connect("pressed", self, "on_pressed")
	update()

func update():
	if type == "SAVE":
		if save_load.slots["slot_"+str(slot)].empty():
			text = "save to slot " + str(slot)
		else:
			text = "overwrite slot " + str(slot)
	else:
		if save_load.slots["slot_"+str(slot)].empty():
			text = "EMPTY"
		else:
			text = "load slot " + str(slot)

func on_pressed():
	match type:
		"SAVE":
#			save_load.save_to_slot("slot_"+str(slot))
			save_load.save_to_file(slot)
		"LOAD":
#			if ! save_load.slots["slot_"+str(slot)].empty():
#				save_load.load_from_slot("slot_"+str(slot))
			save_load.load_from_file(slot)
	for x in get_tree().get_nodes_in_group("save_load_button"):
		x.update()
