extends KinematicBody2D

export var grid_path:NodePath

onready var grid = self.get_node(grid_path)

var direction = Vector2()

const MAX_SPEED = 400

var speed = 0
var velocity:Vector2 = Vector2()
#var path:PoolVector2Array = PoolVector2Array() setget set_path
var world_target_pos = Vector2()
var target_direction = Vector2()
var pos_on_grid:Vector2
var is_moving:bool = false
var is_moving_by_touch:bool = false
var type

func _ready() -> void:
  set_physics_process(true)
  self.type = grid.PLAYER

func _physics_process(delta:float) -> void:
  direction = Vector2()
  speed = 0

#  for i in range(path.size()) :
#    target_direction = self.position.direction_to(path[0]).round()
#    if grid.is_cell_vacant(path[0], target_direction):
#      world_target_pos = grid.update_child_pos(path[0], target_direction, self.type)
#      self.position = self.move_and_slide(world_target_pos, Vector2.ZERO,true, 0,0.785398,false)
#      path.remove(0)

  if Input.is_action_pressed("ui_up"):
    direction = Vector2.UP
  elif Input.is_action_pressed("ui_down"):
    direction = Vector2.DOWN
  elif Input.is_action_pressed("ui_left"):
    direction = Vector2.LEFT
  elif Input.is_action_pressed("ui_right"):
    direction = Vector2.RIGHT

  if not is_moving and direction != Vector2():
    target_direction = direction.normalized()
    if grid.is_cell_vacant(position, direction):
      world_target_pos = grid.update_child_pos(self.position, direction, self.type)
      is_moving = true

  elif is_moving:
    speed = MAX_SPEED
    velocity = speed * target_direction * delta
    var vel = self.move_and_slide(world_target_pos, Vector2.ZERO,true, 0,0.785398,false)
    self.position = vel
    is_moving = false

#func move_along_path(distance:float) -> void:
#  var start_point = self.position
#  for i in range(path.size()):
#    var distance_to_next:float = start_point.distance_to(path[0])
#    if distance <= distance_to_next and distance >= 0.0:
#      var vel = self.move_and_slide(path[0], Vector2.ZERO,true, 0,0.785398,false)
#      position = start_point.linear_interpolate(vel, distance / distance_to_next).round()
#      break
#    elif distance < 0.0:
#      self.position = path[0]
#      break
#    distance -= distance_to_next
#    start_point = path[0]
#    path.remove(0)

#func set_path(new_path:PoolVector2Array) -> void:
#  path = new_path
#  if new_path.size() == 0: return;