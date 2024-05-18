extends Area2D
var range = 10;
var dmg = 5;
var atkspd = .333;
var chmod = false;
var locked = false;
var enemies;
var closest;
var rotate;
var timer
var health = 50

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  timer = timer + delta
  enemies = self.get_overlapping_bodies()
  if enemies.is_empty():
    pass
  var closestDist = 9999999;
  for x in enemies:
    if(x.distance_to(self.position)<closestDist):
      closest = x;
  if(timer>=atkspd):
    fire(closest)
    timer = 0
  pass

func fire(e: Node2D):
  var C:Vector2 = self.position;
  var B:Vector2 = Vector2(0, 1);
  var A = e.position-C;
  var c = sqrt(abs(pow(A.x-B.x, 2)+pow(A.y-B.y, 2)));
  var b = sqrt(abs(pow(A.x-C.x, 2)+pow(C.y-A.y, 2)));
  var a = sqrt(abs(pow(C.x-B.x, 2)+pow(C.y-B.y, 2)));
  var d = acos((pow(a, 2)+pow(b, 2)-pow(c, 2))/2*a*b)
  if (e.position.x < c.x):
    d = 360- d
  rotate = floor(d/45);
  closest.damage(dmg);
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
