extends Control

export var room_path:NodePath
onready var room:Node2D = get_node(room_path)

func _ready() -> void:
  $transition_layer.in_trans()
  yield($transition_layer, "animation_finished")

func _on_level_0_win() -> void:
  $transition_layer.out_trans()
  yield($transition_layer, "animation_finished")
  print_debug("WIN")


func _on_level_0_lose() -> void:
  print_debug("LOSE")


func _on_room0_player_available(player) -> void:
  pass