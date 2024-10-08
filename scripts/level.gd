extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b 

# Called when the node enters the scene tree for the first time.
func _ready():
	$LeftDock/AnimationPlayer.play("osc")
	$RightDock/AnimationPlayer.play("osc")


func draw_level(level):
	$Sky.play(str(level))
	$stars.play(str(level))
	$moon.play(str(level))
	$Castle.play(str(level))
	$Ground.play(str(level))
	$stars/AnimationPlayer2.play("stars")
	$moon/AnimationPlayer.play("moon")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global.docked == 1:
		$RightDock.visible = false
	elif global.docked == -1:
		$LeftDock.visible = false
	else:
		$LeftDock.visible = true
		$RightDock.visible = true
