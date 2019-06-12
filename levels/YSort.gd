extends YSort

func _ready() -> void:
  for child in self.get_children():
    child.grid = self.get_parent()
    child.type = self.get_parent().TILE_TYPE[child.TYPE]