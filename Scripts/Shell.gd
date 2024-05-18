extends Node

@onready var history_wrapper = $VBoxContainer/HistoryWrapper
@onready var prompt = $VBoxContainer/Prompt

@export var root = "user://files"
@export var startingDir: String = "/home/ash"
var current: DirAccess
var history_template = preload("res://Scenes/HistoryLine.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  if not DirAccess.dir_exists_absolute(root + startingDir):
    DirAccess.make_dir_recursive_absolute(root + startingDir)
  current = DirAccess.open(root + startingDir)
  print(current)
  update_prompt()
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func cmd(input: String):
  print(input)
  var split = input.split(" ")
  if split.size() == 0:
    return
  var cmd = split[0]
  var args = split.slice(1)
  var non_flags: PackedStringArray = PackedStringArray([])
  var flags: PackedStringArray = PackedStringArray([])
  for arg in args:
    if arg.begins_with("-"):
      flags.append(arg)
    else:
      non_flags.append(arg)
  var currentPath = current.get_current_dir().trim_prefix(root)

  var prev_cmd: RichTextLabel = history_template.instantiate()
  prev_cmd.append_text("{path}$ {cmd}".format({"path": currentPath, "cmd": input}))
  print(current.get_current_dir())
  match cmd:
    "ls":
      var files
      var folders
      if non_flags.size() == 0:
        files = current.get_files()
        folders = current.get_directories()
        var all = files + folders
        all.sort()
        prev_cmd.newline()
        prev_cmd.append_text("{files}".format({"files": " ".join(all)}))
      else:
          var printed = 0
          for path in non_flags:
            if path.is_empty():
              continue
            if printed != 0:
              prev_cmd.newline()
            printed += 1
            prev_cmd.newline()
            prev_cmd.append_text(path + ":")
            prev_cmd.newline()
            var filepath = current.get_current_dir() + "/" + path
            files = current.get_files_at(filepath)
            folders = current.get_directories_at(filepath)
            var all = files + folders
            all.sort()
            print(all)
            print(files)
            print(folders)
            prev_cmd.append_text("{files}".format({"files": " ".join(all)}))
            print(prev_cmd.text)

    "mkdir":
      for folder in non_flags:
        if folder.is_empty():
          continue
        var a = folder.split("/")
        var b = a[a.size() - 1]
        var c = b.split("_")
        if c.size() != 3:
          continue
        if c[0] != "tower":
          continue
        current.make_dir(folder)
        print(c[1])
        print(c[2])
        var tm = self.get_parent().get_parent().get_child(0) as TileMap
        tm.set_cell(1, Vector2i(int(c[1]) * 2, int(c[2]) * 2), 2, Vector2i(0,0), 2)

    "touch":
      for filename in non_flags:
        if filename.is_empty():
          continue
        if current.file_exists(filename):
          continue
        var folder_pointer = DirAccess.open(current.get_current_dir())
        var path_arr = filename.split(" ")
        var folder_path = "/".join(path_arr.slice(0, path_arr.size() - 1))
        folder_pointer.change_dir(folder_path)
        var abs_file = folder_pointer.get_current_dir() + "/" + path_arr[path_arr.size() - 1]
        var file = FileAccess.open(abs_file, FileAccess.WRITE_READ)
    "cd":
      if args.size() == 0:
        print(root+startingDir)
        current.change_dir(root + startingDir)
      else:
        current.change_dir(args[0])
      update_prompt()
    "rm":
      var recursive: bool = false;
      for flag in flags:
        if flag.begins_with("--"):
          continue
        if flag.contains("r"):
          recursive = true
      for file in non_flags:
        var is_file = current.file_exists(file)
        var is_folder = current.dir_exists(file)
        if is_folder and not recursive:
          prev_cmd.newline()
          prev_cmd.append_text("rm: cannot remove '{file}': Is a directory".format({"file": file}))
          continue
        if not is_file and not is_folder:
          prev_cmd.newline()
          prev_cmd.append_text("rm: cannot remove '{file}': No such file or directory".format({"file": file}))
          continue
        var code = current.remove(file)
        if code == 1 and is_folder:
          var path = current.get_current_dir() + "/" + file
          var has_files: bool = current.get_files_at(path).size() > 0
          var has_folders: bool = current.get_directories_at(path).size() > 0
          if has_files or has_folders:
            recursive_delete(path)
        current.remove(file)
    #"cp":
      #var recursive: bool = false;
      #if non_flags.size() == 0:
        #prev_cmd.append_text("cp: missing file operand")
      #elif non_flags.size() == 1:
        #prev_cmd.append_text("cp: missing destination file operand after '{file}'".format(non_flags[0]))
      #else:
        #for flag in flags:
          #if flag.begins_with("--"):
            #continue
          #if flag.contains("r"):
            #recursive = true
        #var target = non_flags[non_flags.size() - 1]
        #if not current.dir_exists(target):
          #prev_cmd.append_text("cp: cannot stat '{path}': no such file or directory".format({"path": target}))
        #else:
          #for file in non_flags.slice(0, non_flags.size() - 1):
            #var is_file = current.file_exists(file)
            #var is_folder = current.dir_exists(file)
            #if is_folder and not recursive:
              #prev_cmd.append_text("cp: -r not specified; omitting directory '{folder}'".format({"folder": file}))
              #continue
            #var  code = current.copy(file, target)
            #print(code)
    "exit":
      get_tree().quit()
      #self.queue_free()
  history_wrapper.add_child(prev_cmd)

func recursive_delete(root_folder: String):
  for file in current.get_files_at(root_folder):
    current.remove(root_folder+"/"+file)
  for folder in current.get_directories_at(root_folder):
    var folderPath = root_folder+"/"+folder
    var code = current.remove(folderPath)
    if code == 1:
      var has_files: bool = current.get_files_at(folderPath).size() > 0
      var has_folders: bool = current.get_directories_at(folderPath).size() > 0
      if has_files or has_folders:
        recursive_delete(folderPath)

func update_prompt():
  prompt.formatted_prompt = prompt.prompt.format({"path": current.get_current_dir().trim_prefix(root)})
  prompt.init()
