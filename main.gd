extends Control

export var loading_scene:PackedScene

onready var loading_thread = Thread.new()

func _ready() -> void:
  REG.add_scene("loading_screen", loading_scene)
  var loading_i = REG.get_scene("loading_screen").instance()
  loading_thread.start(self, "load_data", loading_i)
  self.add_child(loading_i)

func load_data(loading_i:Node) -> int:

  var scenes_dir = Directory.new()
  scenes_dir.open("res://scenes")
  scenes_dir.list_dir_begin(true, true)
  var scene_file:String = scenes_dir.get_next()
  while scene_file.length() > 0:
    var node = load("res://scenes/%s" % scene_file)
    var scene_name = (scene_file as String).replace(".tscn", "")
    REG.add_scene(scene_name, node)
    scene_file = scenes_dir.get_next()
  yield(self.get_tree().create_timer(2.0), "timeout")
  print_debug(REG._scenes.keys())
  loading_i.is_loading = false
  return 0
