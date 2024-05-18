extends Area2D

@export var health: float = 100
@export var mode: int = 0
@export var speed: float = 3
@export var dmg: float = 0
@export var target: Vector2 = Vector2(0, 0)
var currentTarget = target

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  var intersecting = self.get_overlapping_bodies()
  if intersecting.size() > 0:
    currentTarget = (intersecting[0] as Node2D).position
    self.attack(currentTarget)
  else:
    currentTarget = target

  var distance = Vector2(target.x - self.position.x, target.y - self.position.y)
  self.position.x += min(speed, abs(distance.x)) * sign(distance.x) * delta
  self.position.y += min(speed, abs(distance.y)) * sign(distance.y) * delta

func set_mode(mde:int):
  mode = mde;
  health = 50 * mode
  speed = 3 * mode
  dmg = 5 * mode
  pass

func damage(dmg:int):
  health -= dmg
  if health<=0:
    self.kill()

func attack(targ):
  targ.damage(dmg)

func kill():
  self.queue_free()
