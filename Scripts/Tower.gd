extends Node2D
@export var range = 10;
@export var dmg = 5;
@export var atkspd = .333;
var chmod = false;
var locked = false;
var enemies;
var rotate;
var timer = 0
@export var health = 50

@onready var building = $Building
@onready var attack_range = $"Attack Range"
@onready var animated_sprite_2d = $Building/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  timer = timer + delta
  enemies = attack_range.get_overlapping_areas()
  if enemies.is_empty():
    pass
  var closest = null;
  var closestDist = 9999999;
  for x in enemies:
    if(x.position.distance_to(self.position)<closestDist):
      closest = x;
  if timer>=atkspd and closest != null:
    fire(closest)
    timer = 0
  pass

func fire(e: Node2D):
  #var C:Vector2 = self.position;
  var C: Vector2 = Vector2(0, 0)
  var B: Vector2 = Vector2(0, 1);
  var A = e.position-self.position;
  A.y = -A.y
  var c = sqrt(abs(pow(A.x-B.x, 2)+pow(A.y-B.y, 2)));
  var b = sqrt(abs(pow(A.x-C.x, 2)+pow(C.y-A.y, 2)));
  var a = sqrt(abs(pow(C.x-B.x, 2)+pow(C.y-B.y, 2)));
  var d = rad_to_deg(acos((pow(a, 2)+pow(b, 2)-pow(c, 2))/(2*a*b)))
  if (e.position.x < self.position.x):
    d = 360 - d
  if d < 22.5 or d > 360 - 22.5:
    animated_sprite_2d.play("north")
  elif d < 45 + 22.5:
    animated_sprite_2d.play("north_east")
  elif d < 90 + 22.5:
    animated_sprite_2d.play("east")
  elif d < 135 + 22.5:
    animated_sprite_2d.play("south_east")
  elif d < 180 + 22.5:
    animated_sprite_2d.play("south")
  elif d < 225 + 22.5:
    animated_sprite_2d.play("south_west")
  elif d < 270 + 22.5:
    animated_sprite_2d.play("west")
  elif d < 315 + 22.5:
    animated_sprite_2d.play("north_west")

  e.damage(dmg);
  pass

func upgrade():
  range +=10
  health+=50
  dmg +=5

func damage(dmg:int):
  health-=dmg
  if(health<=0):
    self.queue_free()
  pass
