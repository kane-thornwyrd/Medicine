extends Node2D

#onready var nav2D:Navigation2D = $nav2D
#onready var player:KinematicBody2D = $nav2D/grid/player
#onready var grid:TileMap = $nav2D/grid
#onready var line:Line2D = $line2D

#func _unhandled_input(event:InputEvent) -> void:
#  if not event is InputEventMouseButton: return;
#  if event.button_index != BUTTON_LEFT or not event.pressed: return;
#
#  var evpos = grid.update_child_pos(event.position)
#
#  var new_path:PoolVector2Array = nav2D.get_simple_path(player.position, evpos, false)
#
#  for i in range(new_path.size()):
#    new_path[i] = grid.update_child_pos(new_path[i])
#    var next_dir:Vector2
#    if i+1 != new_path.size():
#      next_dir = grid.world_to_map(new_path[i])\
#        .direction_to(grid.world_to_map(new_path[i+1]))\
#        .round()
#    else:
#      next_dir = grid.world_to_map(new_path[i])\
#        .direction_to(grid.world_to_map(evpos) + Vector2(0,32))\
#        .round()
#
#    while int(next_dir.x) != 0 and int(next_dir.y) != 0:
#      new_path[i] = grid.update_child_pos(new_path[i], Vector2(next_dir.x, 0))
#      new_path.insert(i+1, grid.update_child_pos(new_path[i], Vector2(0, next_dir.y)))
#      i += 1
#      next_dir = new_path[i].direction_to(new_path[i+1]).round()
#
#    print_debug(new_path)
#
#  line.points = new_path
#  player.path = new_path
