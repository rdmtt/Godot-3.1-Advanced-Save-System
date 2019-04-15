
extends Node2D

func _ready():
	get_tree().set_pause(true)
	save_load.load_map()

func _on_load_timeout(): # Yield() doesn't work in ready() so an autostart timer is needed
	save_load.update_current_data()
	yield(save_load.time(0.1), "timeout")
	get_tree().set_pause(false)