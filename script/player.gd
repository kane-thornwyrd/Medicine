extends KinematicBody2D

var speed:float = 400
var path:PoolVector2Array = PoolVector2Array() setget set_path

func _ready() -> void:
  set_process(false)

func _process(delta: float) -> void:
  var move_distance:float = speed * delta
  move_along_path(move_distance)

func move_along_path(distance:float) -> void:
  var start_point = self.position
  for i in range(path.size()):
    var distance_to_next:float = start_point.distance_to(path[0])
    if distance <= distance_to_next and distance >= 0.0:
      position = start_point.linear_interpolate(path[0], distance / distance_to_next)
      break
    elif distance < 0.0:
      self.position = path[0]
      set_process(false)
      break
    distance -= distance_to_next
    start_point = path[0]
    path.remove(0)

func set_path(new_path:PoolVector2Array) -> void:
  path = new_path
  if new_path.size() == 0: return;
  set_process(true)