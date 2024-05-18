extends Area2D

@onready var enemy_manager = %EnemyManager

@onready var health_bar = $HealthBar
@export var maxHealth: float = 100
var health = maxHealth
@export var mode: int = 0
@export var speed: float = 10
@export var dmg: float = 0
#@export var target: Vector2 = Vector2(0, 0)
var target: Vector2 = Vector2(0,0)
var currentTarget = target

# Called when the node enters the scene tree for the first time.
func _ready():
  health_bar.value = health
  health_bar.max_value = maxHealth
  pass # Replace with function body.

func _process(delta):
  health_bar.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  var intersecting = self.get_overlapping_areas()
  if intersecting.size() > 0:
    currentTarget = (intersecting[0] as Node2D).position
    self.attack((intersecting[0] as Area2D).get_parent())
  else:
    currentTarget = target

  var distance = Vector2(target.x - self.position.x, target.y - self.position.y)
  var denominator = abs(distance.x) + abs(distance.y)
  var x = distance.x / denominator * delta * speed
  var y = distance.y / denominator * delta * speed
  self.position.x += x
  self.position.y += y

func set_mode(mde:int):
  mode = mde;
  #health = 50 * mode
  #speed = 3 * mode
  dmg = 5 * mode
  pass

func damage(dmg:int):
  health -= dmg
  if health<=0:
    self.kill()

func attack(targ):
  if targ.has_method("damage"):
    targ.damage(dmg)

func kill():
  #enemy_manager.gold += 1
  self.get_parent().gold += 1
  self.queue_free()
