extends Area2D
var WaveNum = 0;
var distance = 10;
var rng = RandomNumberGenerator.new();
const enemies = ["res://Scenes/Enemy1.tscn", "res://Scenes/Enemy2.tscn", "res://Scenes/Enemy3.tscn"];

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if self.get_overlapping_bodies().is_empty():
    newWave()
    for n in WaveNum*3:
      var rng = round(rng.randf_range(0, floor(WaveNum/5)))
      spawnEnemy(rng%3, rng/3, distance)
  pass
func spawnEnemy(enemy:int, mode:int, dist:int):
  var scene = load(enemies[enemy])
  var spawnedEnemy = scene.instantiate()
  spawnedEnemy.setMode(mode+1)
  var degrees = rng.randf_range(0, 120)-60
  spawnedEnemy.position = Vector2(sin(degrees)*distance, cos(degrees)*distance)
  spawnedEnemy.setPos(degrees, distance);
  pass
func setDist(d:int):
  distance=d
  pass
func newWave():
  WaveNum +=1

  pass
