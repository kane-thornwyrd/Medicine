extends Node2D

onready var nav2D:Navigation2D = $nav2D
onready var player:KinematicBody2D = $player
onready var line:Line2D = $line2D

func _unhandled_input(event:InputEvent) -> void:
  if not event is InputEventMouseButton: return;
  if event.button_index != BUTTON_LEFT or not event.pressed: return;

  var new_path:PoolVector2Array = nav2D.get_simple_path(player.global_position, event.global_position)
  line.points = new_path
  player.path = new_path
