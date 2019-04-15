extends Node2D

export(String, FILE, "*.tscn") var map
export var pos_id = ""


func _on_Area2D_body_entered(body):
	if body == G.player():
		get_tree().set_pause(true)
		save_load.update_current_data()
		G.change_level(map, pos_id)
