extends Area2D@export var spawn_distance = 100;

var gold = 0;
var wave = 0;
var RNG = RandomNumberGenerator.new();
const enemies = ["res://Scenes/Enemy.tscn","res://Scenes/Enemy.tscn","res://Scenes/Enemy.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  if self.get_overlapping_areas().is_empty():
    wave += 1
    for n in wave * 3:
      var rng = RNG.randi_range(0, floori(wave / 5))
      # every 5 waves new
      # start with 1 type
      spawn_enemy(rng % 3, rng / 3)
  pass

func spawn_enemy(enemy: int, mode: int):
  #pass
  var enemy_scene = load(enemies[enemy])
  var spawned_enemy = enemy_scene.instantiate()
  spawned_enemy.set_mode(mode+1)
  var degrees = RNG.randf_range(0, 120)-60
  print(degrees)
  print(sin(degrees))
  print(cos(degrees))
  spawned_enemy.position = Vector2(sin(deg_to_rad(degrees)) * spawn_distance, -cos(deg_to_rad(degrees)) * spawn_distance)
  print(spawned_enemy.position)
  add_child(spawned_enemy)
  pass
