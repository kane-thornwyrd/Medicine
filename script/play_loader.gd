extends Control

func _ready() -> void:
  $pause_menu/pause_modal.visible = false
  $transition_layer.in_trans()
  yield($transition_layer, "animation_finished")