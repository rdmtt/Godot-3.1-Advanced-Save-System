
extends KinematicBody2D

var HP = 100
var time_alive = 0

var next_pos_ID = ""

const RUN = 400
const WALK = 250

var dir = Vector2()
var velocity = Vector2()
var movement_mult = WALK


func _physics_process(delta):

	dir = Vector2()

	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		dir.x = -1

	if Input.is_action_pressed("ui_down"):
		dir.y = 1
	elif Input.is_action_pressed("ui_up"):
		dir.y = -1

	if Input.is_action_pressed("run"):
		movement_mult = RUN
	else:
		movement_mult = WALK

	velocity = (dir.normalized() * movement_mult)

	velocity = move_and_slide(velocity, Vector2())

	time_alive += 0.05


func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == 2 and ev.pressed:
		print("HELLO")
		var g = load("res://entities/godoty.tscn").instance()
		g.global_position = ev.position
		G.level_root().get_node("main").add_child(g, true)
		# VERY IMPORTANT! Add children with human-readable names - add_child([path], TRUE)


func save_this():
	var dict = {}

	dict.time_alive = self.time_alive
	dict.HP = self.HP

	return dict