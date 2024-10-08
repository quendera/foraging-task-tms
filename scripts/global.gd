extends Node

var current_scene = null
var Version = "0.2"

var level = 0
var docked = 0
var active_side
var side
var can_poke
var trial = 0
var ID
var save_file_name
var FlipData
var Score = 0
var Task = "FlipKids"
var MaxStreaks = 100
var RwdSize
var PFlip
var PTrans
var PRwd
var ActiveSide
var LargeSide
var Speed = 10
var Streak
var CurrentTime
var trial_start
var direction = 1

var ABSeed
var change

var RwdSizeMaster = 10
var PRewMaster = 0.9
var PFlipMaster = 0.3
var Goal = 800


var device_ID = Vector2(0,0)

var RandFlip = randf()
var RandValue = randf()
var RandReward = randf()

var root

func _ready():
	init_file()
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	active_side = randi() % 2

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	

func init_file():
	ID = OS.get_unix_time()
	global.ABSeed = randi()%2 
	save_file_name = str(ID)
	
#build data dict
	FlipData = {
		"trial":[],
		"trial_time":[],
		"event":[],

		"score":[],

		
		#session metadata
		"subj_id":[],
		"task":[],
		"version":[],
		"start_time":[], #redundant
		
		#input
		
		#settings
		"max_streaks":[],
		"reward_size_left":[],

		"prob_flip":[],
		"prob_trans":[],
		"prob_rwd":[],
		"active_side":[],
		"travel_speed":[],
		"iti":[],
		"streak":[],
		"log_time":[],
		"rand_flip":[],

		"rand_reward":[]
		}

func log_data(Event):
	#trial info
	FlipData["trial"].push_back(global.trial)
	FlipData["trial_time"].push_back(global.trial_start)
	FlipData["event"].push_back(Event)

	FlipData["score"].push_back(Score)

	
	#session metadata
	FlipData["subj_id"].push_back(device_ID)
	FlipData["task"].push_back(Task)
	FlipData["version"].push_back(Version)
	FlipData["start_time"].push_back(ID) #redundant
	
	#input
	
	#settings
	FlipData["max_streaks"].push_back(MaxStreaks)
	FlipData["reward_size_left"].push_back(global.RwdSize)
	FlipData["prob_flip"].push_back(PFlip)
	FlipData["prob_trans"].push_back(PTrans)
	FlipData["prob_rwd"].push_back(PRwd)
	FlipData["active_side"].push_back(active_side)

	FlipData["travel_speed"].push_back(Speed)
	FlipData["iti"].push_back(int(1))
	FlipData["streak"].push_back(Streak)
	FlipData["log_time"].push_back(CurrentTime)
	FlipData["rand_flip"].push_back(RandFlip)
	FlipData["rand_reward"].push_back(RandReward)

func end_task():
	var file = File.new()
	file.open(str("user://F", save_file_name, ".json"), file.WRITE)
	file.store_line(to_json(FlipData))
	file.close()
	global.goto_scene("res://scenes/Main.tscn")
