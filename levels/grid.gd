extends TileMap

signal lose
signal win

enum TILE_TYPE {VOID = -1, EMPTY = 0, GOAL = 1, MOVABLE = 3, COLLECTIBLE = 2, PLAYER = 4}

export var child_container_path:NodePath
export var nav2D_path:NodePath

var half_cell_size = self.cell_size / 2
var grid_size

var grid = {}
onready var child_container:Node = self.get_node(child_container_path)
onready var nav2D:CanvasModulate = self.get_node(nav2D_path)

var shortest_path:PoolVector2Array
var goal_coords:Vector2
var pill_coords:Vector2
var move_cost:float = 0
var total_cost:float = 1

func _ready():
  self.position = Vector2.ZERO
  grid_size = self.get_used_rect()
  var slab_cost:int = 0

  for x in range(grid_size.position.x, grid_size.position.x + grid_size.size.x):
    grid[x] = {}
    for y in range(grid_size.position.y, grid_size.position.y + grid_size.size.y):
      var current_cell = self.get_cell(x, y)
      if current_cell == self.INVALID_CELL :
        grid[x][y] = TILE_TYPE.VOID
#        self.set_cell(x,y,1)
      elif current_cell >= 0 :
        match current_cell:
          TILE_TYPE.GOAL:
            grid[x][y] = TILE_TYPE.GOAL
            goal_coords = Vector2(x,y)
          _:
            grid[x][y] = current_cell
  for child in child_container.get_children():
    if child is Player:
      child.position = update_child_pos(child.position, Vector2.ZERO, TILE_TYPE[child.TYPE])
      shortest_path = nav2D.get_simple_path(child.position, map_to_world(goal_coords), false)
      child.anim_player.connect("animation_finished", self, "_player_react")
    if child is Pill:
      child.position = update_child_pos(child.position, Vector2.ZERO, TILE_TYPE[child.TYPE])
      pill_coords = child.position
    if child is Slab:
      child.position = update_child_pos(child.position, Vector2.ZERO, TILE_TYPE[child.TYPE])
      slab_cost += 3

  var estimated_cost = float(max(shortest_path.size(),1) * pow(max(slab_cost,10), 1+1/6)) / 10.0

  move_cost = UTILS.float_crop(1.0 / estimated_cost, 3, UTILS.OPERATION.CEIL)


func get_cell_entity_type(pos:Vector2) -> int:
  if grid.has(int(pos.x)) and grid[int(pos.x)].has(int(pos.y)):
    return grid[int(round(pos.x))][int(round(pos.y))]
  else:
    return TILE_TYPE.VOID

func set_cell_entity_type(pos:Vector2, type:int) -> void:
  if grid.has(int(pos.x)) and grid[int(pos.x)].has(int(pos.y)):
    grid[int(pos.x)][int(pos.y)] = type

func get_cell_nodes(pos:Vector2) -> Array:
  var output:Array = []
  for child in child_container.get_children():
    if world_to_map(child.position) == pos:
      output.append(child)
  return output

## Check if cell at direction is vacant
func is_cell_vacant(this_grid_pos:Vector2, dir:Vector2):
  var target_grid_pos = world_to_map(this_grid_pos) + dir
  if not grid.has(int(target_grid_pos.x)) : return false;
  if not grid[int(target_grid_pos.x)].has(int(target_grid_pos.y)) : return false;
  if grid[int(target_grid_pos.x)][int(target_grid_pos.y)] == self.TILE_TYPE.VOID:
    return false
  if grid[int(target_grid_pos.x)][int(target_grid_pos.y)] == self.TILE_TYPE.MOVABLE and \
     not is_cell_vacant(map_to_world(target_grid_pos), dir) :
    return false
  return true


## Remove node from current cell, add it to the new cell,
## returns the new world target position
func update_child_pos(this_world_pos, dir:Vector2 = Vector2.ZERO, type = null):

  var this_grid_pos = world_to_map(this_world_pos)
  var new_grid_pos = this_grid_pos + dir

  if dir == Vector2.ZERO:
    if type == TILE_TYPE.COLLECTIBLE:
      self.set_cell( this_grid_pos.x, this_grid_pos.y, TILE_TYPE.COLLECTIBLE)


  if dir != Vector2.ZERO:
    if type == TILE_TYPE.PLAYER:
      var player:Player = get_cell_nodes(this_grid_pos)[0]
      set_cell_entity_type(this_grid_pos, TILE_TYPE.VOID)
      self.set_cell( this_grid_pos.x, this_grid_pos.y, TILE_TYPE.VOID)
      self.update_dirty_quadrants()
      var cell_type = get_cell_entity_type(new_grid_pos)
      if not [ TILE_TYPE.COLLECTIBLE,  TILE_TYPE.GOAL].has(cell_type) :
        total_cost -= move_cost
      match cell_type:
        TILE_TYPE.COLLECTIBLE:
          for child in child_container.get_children():
            if child is Pill:
              child.taken()
          total_cost = 1
        TILE_TYPE.GOAL:
          if total_cost > 0:
            player.is_winning = true
        TILE_TYPE.MOVABLE:
          var movable:Slab = get_cell_nodes(new_grid_pos)[0]
          var push_dir = this_grid_pos.direction_to(new_grid_pos)
          var futur_pos = new_grid_pos + push_dir
          var next_cell_type = get_cell_entity_type(futur_pos)
          match next_cell_type:
            TILE_TYPE.EMPTY:
              movable.position = update_child_pos(map_to_world(new_grid_pos), push_dir, TILE_TYPE.MOVABLE)
              set_cell_entity_type(new_grid_pos, TILE_TYPE.EMPTY)
            _:
              return this_world_pos


      self.modulate = Color(total_cost,total_cost,total_cost,1)
      print_debug("LIGHTNESS REMAINING %s" % total_cost)
      if total_cost <= 0.03:
        player.is_lost = true
        print_debug("LOST IN THE DARKNESS")
        return this_world_pos

  set_cell_entity_type(new_grid_pos, type)
    # place player on new grid location

#  var test = world_to_map(pill_coords)
  var new_world_pos = map_to_world(new_grid_pos) + Vector2(0,32)
  return new_world_pos

func _player_react(what:String) -> void:
  print_debug("ANIMATION %s" % what)
  match what:
    "die":
      emit_signal("lose")
    "exit":
      emit_signal("win")