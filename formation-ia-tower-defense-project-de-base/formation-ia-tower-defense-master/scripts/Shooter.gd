extends Area2D
class_name Shooter

export (float) var attack_range = 200
export (float) var attack_speed = 1
export (PackedScene) var projectile
var target
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_node("..")
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = attack_range
	collision_shape.set_shape(shape)
	add_child(collision_shape)
	var timer = Timer.new()
	add_child(timer)
	timer.start(1 / attack_speed)
	timer.connect("timeout", self, "shoot")

func shoot():	
	if target && !overlaps_area(target):
		target = null
	if !target:
		var overlapping = get_overlapping_areas()
		for obj in overlapping:
			target = obj
			break
	if target:
		var bullet = projectile.instance()
		parent.get_node("..").add_child(bullet)
		bullet.collision_layer = 0
		bullet.collision_mask = collision_mask
		bullet.position = parent.position
		bullet.fire((target.position - parent.position).normalized())
