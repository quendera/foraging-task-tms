extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = 0
var Speed = global.Speed
var touch_x_pos = 0
var touch_y_pos = 0
var keyboard = 0
var right_dock = 1680
var left_dock = 240
signal docked
signal undocked
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("stop")



func _process(_delta):
	if not $AnimatedSprite.is_playing():
		if self.global_position.x > right_dock or self.global_position.x < left_dock:
			dock(global.direction)
		elif global.docked == 0:
			$AnimatedSprite.play("stop")
#			
#		elif self.global_position.x < 300:
#			$AnimatedSprite.play("dock")
#			self.global_position.x = 299
#		else:
#			$AnimatedSprite.play("stop")

func dock(side):
	global.can_poke = 1
	$AnimatedSprite.play("dock")
	emit_signal("docked",side)
	if side == -1:
		self.global_position.x = left_dock + 1
		global.docked = side
		global.side = 0
		
	elif side == 1:
		self.global_position.x = right_dock - 1
		global.docked = side
		global.side = 1

func _physics_process(_delta):
	if moving != 0 and (self.global_position.x > left_dock and self.global_position.x < right_dock) and (touch_y_pos > 955 or keyboard == 1):
		if (moving == 1 and touch_x_pos < self.global_position.x and keyboard == 0) or (moving == -1 and touch_x_pos > self.global_position.x and keyboard == 0):
			pass
		else: 
			move(global.Speed*moving)
			global.direction = moving


func _input(event):
#	if event is InputEventKey:
#		#MOVEMENT
#		#Move Left
	if event.is_action_pressed("ui_left"):
		keyboard = 1
		moving = -1
	#Move Right
	elif event.is_action_pressed("ui_right"):
		keyboard = 1
		moving = 1
	elif event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		keyboard = 0
		moving = 0
	elif event is InputEventScreenTouch:
		if !event.is_pressed():
			moving = 0
	elif event is InputEventScreenDrag:
		touch_x_pos = event.position.x
		touch_y_pos = event.position.y
		if event.speed[0] > 0:
			moving = 1
		elif event.speed[0] < 0:
			moving = -1
		else:
			moving = 0
			
#	elif event is InputEventKey and !event.is_echo() and event.is_pressed():
#		if event.scancode == KEY_SPACE:
#			if $Player.get_position()[0] < 400:  #Poke left
#				if LastPokePos == 1:
#					if Streak < MaxStreaks:
#						Streak += 1
#					else:
#						end_task()
#				LastPokePos = 0
#				$Player.scale.x = -1
#				if can_poke == 1:
#					Trial += 1
#					$Player.play_shoot()
#					poke(int(0))
#			elif $Player.get_position()[0] > 1580:   #Poke right
#				if LastPokePos == 0:
#					Streak += 1
#				LastPokePos = 1
#				$Player.scale.x = 1
#				if can_poke == 1:
#					Trial += 1
#					$Player.play_shoot()
#					poke(int(1))
#	#MOVEMENT
#		#Move Left
#	elif event.scancode == KEY_LEFT and $Player.get_position()[0] > 300:
#		move(-Speed)
#		#Move Right
#	elif event.scancode == KEY_RIGHT and $Player.get_position()[0] < 1680:
#		move(Speed)



func move(dir):
	global.docked = 0
	emit_signal("undocked")
	self.translate(Vector2(dir,0))
	self.play_walk()
	self.scale.x = -moving

func play_shoot():
	$AnimatedSprite.play("shoot")

func play_walk():
	$AnimatedSprite.play("walk")

func _on_AnimatedSprite_animation_finished():
	self.scale.x = global.direction
	$AnimatedSprite.stop()
