extends Area2D
var health
var mode
var speed
var dmg
var direction
var building
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+=delta
	if(self.get_overlapping_bodies().is_empty()):
		if(timer>=100):
			self.position = Vector2();
		pass
	building=self.get_overlapping_bodies[0]
	pass

func setMode(mde:int):
	mode = mde;
	health = 50*mode
	speed = 3*mode
	dmg = 5*mode
	pass

func damage(dmg:int):
	health -= dmg
	pass

func setDir(dir:int):
	direction = dir
	pass

func attack():
	pass
