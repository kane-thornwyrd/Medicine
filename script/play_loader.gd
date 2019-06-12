extends Control

onready var level_container = $level/level_container

func _ready() -> void:
  var room0:Room = ROOM_REG.get_room("room0").instance()



  $transition_layer.in_trans()
  yield($transition_layer, "animation_finished")

func _on_level_win() -> void:
  $transition_layer.out_trans()
  yield($transition_layer, "animation_finished")
  print_debug("WIN")

func _on_level_lose() -> void:
  $transition_layer.out_trans()
  yield($transition_layer, "animation_finished")
  print_debug("LOSE")