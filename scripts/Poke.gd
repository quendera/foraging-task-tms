extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal poked
signal barrier
signal update_score
signal end_poke

var TrialStart
var can_poke = 1




# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite/AnimationPlayer.play("spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $AnimatedSprite.animation != "target":
		self.scale = Vector2(0.5,0.5)
		self.rotation_degrees = 0
		$AnimatedSprite/AnimationPlayer.play("stop")
	else:
		$AnimatedSprite/AnimationPlayer.play("spin")
		self.scale = Vector2(1,1)
		

#if event is InputEventMouseButton and event.pressed and not event.is_echo() and event.button_index == BUTTON_LEFT:
#        if get_rect().has_point(event.position):
#            print('test')
#            get_tree().set_input_as_handled() # if you don't want subsequent input callbacks to respond to this input

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and not event.is_echo():
		if global.can_poke == 1:
			emit_signal("poked")

func _input(event):
	if event.is_action_pressed("ui_select"):
		if global.can_poke == 1:
			emit_signal("poked")

func _on_Poke_poked():
	global.trial_start = OS.get_ticks_msec()
	if global.can_poke == 1:
		global.trial +=1
		if global.side == global.active_side:
			global.RandFlip = randf()
			global.RandValue = randf()
			global.RandReward = randf()
			print('aa')
			can_poke = 0
			print("F ", global.RandFlip," V ", global.RandValue, " R ", global.RandReward)
			if global.RandValue <= global.PTrans:
				emit_signal("barrier")
			if global.RandFlip <= global.PFlip:
				poke_flip()
			if global.RandReward <= global.PRwd:
				global.Score = global.Score + global.RwdSize
				print("Reward of ", global.RwdSize, " to a score of ",global.Score)
				emit_signal("update_score")
				$AnimatedSprite.play(str("hit",global.level))
			else:
				$AnimatedSprite.play(str("miss",global.level))
		else:
			can_poke = 0
			$AnimatedSprite.play(str("miss",global.level))
		can_poke = 0
		global.log_data("poke")


func poke_flip():
	global.active_side = abs(global.active_side-1)
	print("flipped to ", global.active_side)
	global.log_data("flip")
	
	



func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "target" :
		pass
	else:
		$AnimatedSprite.play("target")
		emit_signal("end_poke")
#		$Feedback.set_text("")
		global.can_poke = 1
