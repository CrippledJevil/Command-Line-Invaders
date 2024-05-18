extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
  self.show()
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  self.text = $EnemyManager.gold
  pass
