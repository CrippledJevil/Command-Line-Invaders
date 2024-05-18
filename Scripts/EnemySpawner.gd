extends Area2D
var WaveNum = 0;
var distance = 10;
var rng = RandomNumberGenerator.new();
var enemies = [$Enemy1, $enemy2, $enemy3];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.get_overlapping_bodies().is_empty():
		for n in WaveNum*3:
			var rng = round(rng.randf_range(0, floor(WaveNum/5)))
			spawnEnemy(rng%3, rng/3, distance)
	pass
func spawnEnemy(enemy:int, mode:int, dist:int):
	var scene = preload("res://Scenes/Enemy1.tscn")
	var spawnedEnemy = scene.instantiate()
	spawnedEnemy.setMode(mode+1)
	var degrees = rng.randf_range(0, 120)-60
	spawnedEnemy.position = Vector2(sin(degrees)*distance, cos(degrees)*distance)
	spawnedEnemy.setPos(degrees, distance);
	pass
func setDist(d:int):
	distance=d
	pass
