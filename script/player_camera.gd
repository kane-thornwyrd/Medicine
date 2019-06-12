extends Camera2D

signal camera_ready(camera)

func _ready() -> void:
  emit_signal("camera_ready", self)