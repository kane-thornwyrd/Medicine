extends KinematicBody2D
class_name Slab

const TYPE = "MOVABLE"

var grid

var type:int

func _ready() -> void:
  set_physics_process(true)
