extends Node


var FlipData
var Task = "Flip"
var RwdSizeL = 4
var RwdSizeR = 4
var ValueMode #toggles value flip on or off. 0 is regular flip, 1 is value flip


var LargeSide #0 for left, 1 for right
var Speed = 5
var Barrier = 1
#var Iti = 500



var can_set = 1

var RwdSide = "RightPoke"

var LastPokePos
var Streak = 0


var CurrentTime
var TimerStart = 0
var Time = 0
var TimerType
var TimerOn

var Version

var StartFlip



# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.max_value = global.Goal
	$ProgressBar.value = global.Goal
	$Score.set_text("")
	var _err = $Player.connect("docked", self, "_on_docked")
	_err = $Player.connect("undocked", self, "_on_undock")
	_err = $Poke.connect("update_score", self, "_on_update_score")
	_err = $Poke.connect("end_poke", self, "_on_end_poke")
	set_protocol(0)
	global.active_side = randi()%2 
	global.PTrans = 0
	StartFlip = OS.get_ticks_msec()
	$Poke.position = Vector2(-100,-100)


func set_protocol(change):
	global.level = 1 + randi()%4 
	$Scenario.draw_level(global.level)
	if change == 2: #90/90
		global.PRwd = global.PRewMaster
		global.PFlip = global.PFlipMaster*2
		global.RwdSize = global.RwdSizeMaster
	elif change == 0: #45/15
		global.PRwd = global.PRewMaster/2 
		global.PFlip = global.PFlipMaster/2
		global.RwdSize = global.RwdSizeMaster
	elif change == 1: #90/30
		global.PRwd = global.PRewMaster
		global.PFlip = global.PFlipMaster
		global.RwdSize = global.RwdSizeMaster
	print(global.RwdSize,global.PFlip)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global.CurrentTime = OS.get_ticks_msec()
	#print(global.CurrentTime)
	if (TimerStart + Time) - global.CurrentTime <= 0 and TimerOn == 1:
		TimerOn = 0
		call(TimerType)
	if ((global.CurrentTime - StartFlip) > 600000 and (global.CurrentTime - StartFlip) < 600300) and can_set == 1:
		set_protocol(1)
		can_set = 0
		print(global.Score == global.Goal)
	if (global.CurrentTime - StartFlip) > 1200000 and (global.CurrentTime - StartFlip) < 1200300 and can_set == 1:
		set_protocol(2)
		can_set = 0


#1602463881
#1000000000

# Collects inputs

func _on_docked(side):
	if side == -1:
		$Scenario/LeftDock.visible = false
	elif side == 1:
		$Scenario/RightDock.visible = false
	$Poke/AnimatedSprite.animation = "target"
	$Poke.visible = 1
	poke_reposition(global.direction)

func _on_end_poke():
	poke_reposition(global.direction)

func poke_reposition(side):
	var vec = Vector2(0,0)
	if side == -1:
		vec = Vector2(randi()%215+425,randi()%130+730)
	elif side == 1:
		vec = Vector2(randi()%280+1260,randi()%130+730)
	$Poke.position = vec


func _on_undock():
	$Scenario/LeftDock.visible = 1
	$Scenario/RightDock.visible = 1
	$Poke.visible = 0


func _on_update_score():
	$ProgressBar.value = global.Goal - global.Score
	print($ProgressBar.value)
	if global.Score >= global.Goal:
		global.end_task()
	print(global.Score > global.Goal/2+global.RwdSize)
	if global.Score >= global.Goal/2 and global.Score < global.Goal/2+global.RwdSize and can_set == 1:
		set_protocol(1)
		can_set = 0

func timer(time, event):
	TimerStart = OS.get_ticks_msec()
	Time = time
	TimerType = event
	TimerOn = 1

func value_flip():
	pass


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		global.end_task()



func _input(event):
	if event is InputEventKey and !event.is_echo() and event.is_pressed():
		can_set = 1
		if event.scancode == KEY_Q or event.scancode == KEY_ESCAPE:
			global.end_task()
