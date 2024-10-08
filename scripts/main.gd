extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	global.Score = 0


func _input(event):
	if event is InputEventKey and !event.is_echo() and event.is_pressed():
		if event.scancode == KEY_F:
			global.goto_scene("res://scenes/Flip.tscn")


func _on_TouchScreenButton_pressed():
	global.goto_scene("res://scenes/Flip.tscn")
