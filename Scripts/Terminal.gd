extends TextEdit

@onready var repeat_timer: Timer = $RepeatTimer
var repeatDelay = 0.3
var repeatSpeed = 0.3

var prompt: String = "ash@Ash:/$ "
var mouseOver: bool = false
var caretPos: Vector2 = Vector2(0,0)
var letters: Array[Key] = [KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P, KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L, KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M]
var currentkey: InputEventKey = InputEventKey.new()
var new_text: String = ""
var caretOffset: Vector2 = Vector2(0,0)
var delete_buffer: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
  self.text = prompt
  caretPos.x = self.text.length()
  new_text = self.text
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  self.text = new_text;
  caretPos.x += self.text.length() - new_text.length()
  self.set_caret_column(caretPos.x)
  self.set_caret_line(caretPos.y)
  #new_text = ""
  pass

var capsLock: bool = false

func _input(event: InputEvent):
  if event is InputEventKey and event.is_pressed() and (event as InputEventKey).key_label == KEY_CAPSLOCK:
    capsLock = !capsLock
  if (self.has_focus()):
    if event is InputEventMouseMotion:
      return # ignore mouse move
    #print("focused")
    if event is InputEventMouseButton:
      # block mouse input inside the terminal
      var mousePos: Vector2 = event.position
      var inX: bool = mousePos.x > self.position.x and mousePos.x < self.position.x + self.size.x
      var inY: bool = mousePos.y > self.position.y and mousePos.y < self.position.y + self.size.y
      # we don't wanna block stuff outside like clicking outside it
      if inX and inY:
        get_viewport().set_input_as_handled()
      return
    get_viewport().set_input_as_handled()
    var keyEvent: InputEventKey = event
    if not event.is_pressed():
      if keyEvent.key_label == KEY_LEFT or keyEvent.key_label == KEY_RIGHT:
        caretOffset = Vector2(0,0)
      if keyEvent.key_label == currentkey.key_label:
        repeat_timer.stop()
      return
    if keyEvent.key_label == KEY_ENTER:
      print(self.text.substr(prompt.length()))
      self.text = prompt
      return
    var char = process_text(keyEvent, false)
    if not char.is_empty():
      caretOffset = Vector2(0,0)
    var left: String = new_text.substr(0, caretPos.x)
    var right: String = new_text.substr(caretPos.x)
    new_text = left + char + right

func process_text(keyEvent: InputEventKey, repeating: bool) -> String:
  var isUppercase: bool = keyEvent.as_text().begins_with("Shift+")
  var char: String = ""
  if letters.has(keyEvent.key_label):
    char = keyEvent.as_text()
    if isUppercase:
      char = char.substr(6)
    print(keyEvent.as_text())
    print(keyEvent.key_label)
    if capsLock:
      isUppercase = not isUppercase
    if isUppercase:
      char = char.to_upper()
    else:
      char = char.to_lower()

    if not repeating:
      repeat_timer.stop()
      currentkey = keyEvent
      repeat_timer.wait_time = repeatDelay
      repeat_timer.start()
    caretPos.x += 1
  else:
    var local_char = keyEvent.as_text()
    if isUppercase:
      local_char = char.substr(6)
    match keyEvent.key_label:
      KEY_SPACE:
        char = " "
      KEY_1:
        char = local_char if not isUppercase else "!"
      KEY_2:
        char = local_char if not isUppercase else "@"
      KEY_3:
        char = local_char if not isUppercase else "#"
      KEY_4:
        char = local_char if not isUppercase else "$"
      KEY_5:
        char = local_char if not isUppercase else "%"
      KEY_6:
        char = local_char if not isUppercase else "^"
      KEY_7:
        char = local_char if not isUppercase else "&"
      KEY_8:
        char = local_char if not isUppercase else "*"
      KEY_9:
        char = local_char if not isUppercase else "("
      KEY_0:
        char = local_char if not isUppercase else ")"
      KEY_QUOTELEFT:
        char = "`" if not isUppercase else "~"
      KEY_MINUS:
        char = "-" if not isUppercase else "_"
      KEY_EQUAL:
        char = "=" if not isUppercase else "+"
      KEY_BRACKETLEFT:
        char = "{" if not isUppercase else "["
      KEY_BRACKETRIGHT:
        char = "}" if not isUppercase else "]"
      KEY_BACKSLASH:
        char = "\\" if not isUppercase else "|"
      KEY_SEMICOLON:
        char = ";" if not isUppercase else ":"
      KEY_APOSTROPHE:
        char = "'" if not isUppercase else "\""
      KEY_COMMA:
        char = "," if not isUppercase else "<"
      KEY_PERIOD:
        char = "." if not isUppercase else ">"
      KEY_SLASH:
        char = "/" if not isUppercase else "?"
      KEY_LEFT:
        if not repeating:
          caretPos.x = int(max(prompt.length() if caretPos.y == 0 else 0, caretPos.x - 1))
          repeat_timer.stop()
          currentkey = keyEvent
          repeat_timer.wait_time = repeatDelay
          repeat_timer.start()
          caretOffset = Vector2(-1, 0)
      KEY_RIGHT:
        if not repeating:
          caretPos.x = int(min(self.get_line(caretPos.y).length(), caretPos.x + 1))
          repeat_timer.stop()
          currentkey = keyEvent
          repeat_timer.wait_time = repeatDelay
          repeat_timer.start()
          caretOffset = Vector2(1, 0)
      KEY_BACKSPACE:
        delete()
        if not repeating:
          repeat_timer.stop()
          currentkey = keyEvent
          repeat_timer.wait_time = repeatDelay
          repeat_timer.start()
    if not char.is_empty():
      if not repeating:
        repeat_timer.stop()
        currentkey = keyEvent
        repeat_timer.wait_time = repeatDelay
        repeat_timer.start()
      caretPos.x += 1
    print(keyEvent.as_text())
    print(keyEvent.key_label)
  return char

func delete():
  if caretPos.y == 0 and caretPos.x == prompt.length():
    return
  var left = new_text.substr(0, caretPos.x - 1)
  var right = new_text.substr(caretPos.x)
  new_text = left + right
  caretPos.x -= 1


func _on_repeat_timer_timeout() -> void:
  if repeat_timer.wait_time == repeatDelay:
    repeat_timer.wait_time = repeatSpeed
  print("timer")
  repeat_timer.stop()
  var char = process_text(currentkey, true)
  var left: String = new_text.substr(0, caretPos.x)
  var right: String = new_text.substr(caretPos.x)
  new_text = left + char + right
  if caretOffset.x < 0:
    caretPos.x = int(max(prompt.length() if caretPos.y == 0 else 0, caretPos.x + caretOffset.x))
  elif caretOffset.x > 0:
    caretPos.x = int(min(self.get_line(caretPos.y).length(), caretPos.x + caretOffset.x))
  repeat_timer.start()
  pass # Replace with function body.
