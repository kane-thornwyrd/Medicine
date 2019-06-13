extends Control

onready var level_container = $level/level_container
onready var transition_screen = $transition_layer

var rooms = [
  ROOM_REG.get_room("room0"),
  ROOM_REG.get_room("room1")
]

var room_number:int = 0

var prev_room:Room

func _ready() -> void:
  load_room()
  $transition_layer.in_trans()
  yield($transition_layer, "animation_finished")

func _on_level_win(room:Room) -> void:
  call_deferred("_disappear_mofo")
  $transition_layer.out_trans()
  yield($transition_layer, "animation_finished")
  room_number += 1
  load_room()

func _on_level_lose(room:Room) -> void:
  call_deferred("_disappear_mofo")
  $transition_layer.out_trans()
  yield($transition_layer, "animation_finished")
  load_room()

func load_room() -> void:
  var room:Room = rooms[room_number % rooms.size()].instance()
  if !prev_room:
    prev_room = room
    room.connect("win", self, "_on_level_win", [room])
    room.connect("lose", self, "_on_level_lose", [room])
  level_container.add_child(prev_room)
  prev_room.raise()
  print_debug("LOADING Room%s" % room_number)
  $transition_layer.in_trans()
  yield($transition_layer, "animation_finished")

func _disappear_mofo() -> void :
  print_debug("GO DIE %s" % prev_room)
  prev_room.position += Vector2(0, -10000)
  prev_room.disconnect("win", self, "_on_level_win")
  prev_room.disconnect("lose", self, "_on_level_lose")
  prev_room.visible = false
  prev_room.modulate = Color(0.0,0.0,0.0,0.0)
  prev_room.queue_free()
  prev_room = null
