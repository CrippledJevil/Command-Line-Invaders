extends Area2D
var health
var mode
var speed
var dmg
var direction
var building
var timer = 0
var distance
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  timer+=delta
  if(self.get_overlapping_bodies().is_empty()):
    if(timer>=100):
      self.position = Vector2(sin(direction)*(distance-speed), cos(direction)*distance-speed);
    pass
  building=self.get_overlapping_bodies()[0]
  self.attack()
  pass

func setMode(mde:int):
  mode = mde;
  health = 50*mode
  speed = 3*mode
  dmg = 5*mode
  pass

func damage(dmg:int):
  health -= dmg
  if health<=0:
    self.death()
  pass

func setPos(dir:int, dist:int):
  direction = dir
  distance = dist
  pass

func attack():
  self.get_overlapping_bodies()[0].damage(dmg)
  pass

func death():
  pass
