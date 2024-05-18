extends Area2D
var wave = 0;
var distance = 10;
var rng = RandomNumberGenerator.new();
const enemies = ["res://Scenes/Enemy.tscn","res://Scenes/Enemy.tscn","res://Scenes/Enemy.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  if self.get_overlapping_bodies().is_empty():
    wave += 1
    for n in wave * 3:
      var rng = rng.randi_range(0, floor(wave / 5))
      # every 5 waves new
      # start with 1 type
      spawn_enemy(rng % 3, rng / 3, distance)
  pass

func spawn_enemy(enemy: int, mode: int, dist: int):
  var enemy_scene = load(enemies[enemy])
  var spawned_enemy = enemy_scene.instantiate()
  spawned_enemy.set_mode(mode+1)
  var degrees = rng.randf_range(0, 120)-60
  spawned_enemy.position = Vector2(sin(degrees) * distance, cos(degrees) * distance)
  pass
