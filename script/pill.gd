extends Node2D
class_name Pill

const TYPE = "COLLECTIBLE"

var grid
var type

func taken() -> void:
  $anim_player.play("taken")
  yield($anim_player, "animation_finished")
  self.queue_free()
