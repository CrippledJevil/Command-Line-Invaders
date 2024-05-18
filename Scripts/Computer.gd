extends Area2D

var terminal_template = preload("res://Scenes/Terminal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func _on_button_button_down():
  print("E")
  var root = self.get_parent().get_parent().get_child(4)
  if root.get_children().size() > 0:
    return
  var term = terminal_template.instantiate()
  root.add_child(term)
  print(root)
  print(root.get_children())
