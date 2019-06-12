extends Control

export var loading_scene:PackedScene

onready var loading_scene_thread = Thread.new()
onready var loading_room_thread = Thread.new()

var all_loaded:Array = [false,false]

func _ready() -> void:
  REG.add_scene("loading_screen", loading_scene)
  var loading_i = REG.get_scene("loading_screen").instance()
  loading_scene_thread.start(self, "load_scene_data", loading_i)
  loading_room_thread.start(self, "load_room_data", loading_i)
  self.add_child(loading_i)

func load_scene_data(loading_i:Node) -> int:
  var scenes_dir = Directory.new()
  scenes_dir.open("res://scenes")
  scenes_dir.list_dir_begin(true, true)
  var scene_file:String = scenes_dir.get_next()
  while scene_file.length() > 0:
    var node = load("res://scenes/%s" % scene_file)
    var scene_name = (scene_file as String).replace(".tscn", "")
    REG.add_scene(scene_name, node)
    scene_file = scenes_dir.get_next()
  print_debug(REG._scenes.keys())
  all_loaded[0] = true
  _refresh_loading_state(loading_i)
  return 0

func load_room_data(loading_i:Node) -> int:
  var rooms_dir = Directory.new()
  rooms_dir.open("res://levels")
  rooms_dir.list_dir_begin(true, true)
  var room_file:String = rooms_dir.get_next()
  while room_file.length() > 0:
    if room_file.ends_with(".tscn"):
      var node = load("res://levels/%s" % room_file)
      var room_name = (room_file as String).replace(".tscn", "")
      ROOM_REG.add_room(room_name, node)
    room_file = rooms_dir.get_next()
  print_debug(ROOM_REG._rooms.keys())
  all_loaded[1] = true
  _refresh_loading_state(loading_i)
  return 0

func _refresh_loading_state(loading_i:Node) -> void:
  loading_i.is_loading = not all_loaded.has(false)