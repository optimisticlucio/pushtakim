class_name BulletMagazine extends Node2D

var showing_left_bullet: bool = true;

@export
var left_sprite: Sprite2D = null;

@export
var right_sprite: Sprite2D = null;

@onready var area: Area2D = $BulletInsertArea

signal bullet_inserted;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite();

func _physics_process(_delta: float) -> void:
	for body in area.get_overlapping_bodies():
		if _fully_inside_x(body):
			body.queue_free()
			new_bullet_inserted()

func _fully_inside_x(body: Node2D) -> bool:
	var area_bounds := _get_x_bounds(area)
	var b := _get_x_bounds(body)
	return b.position.x >= area_bounds.position.x and b.end.x <= area_bounds.end.x

func _get_x_bounds(node: Node2D) -> Rect2:
	for child in node.get_children():
		if child is CollisionShape2D and child.shape != null:
			var r: Rect2 = child.shape.get_rect()
			var half_w = r.size.x * 0.5 * abs(child.global_scale.x)
			var cx = child.global_position.x
			return Rect2(cx - half_w, 0, half_w * 2.0, 1)
		if child is CollisionPolygon2D and child.polygon.size() > 0:
			var min_x := INF
			var max_x := -INF
			var xform = child.global_transform
			for point in child.polygon:
				var gx = (xform * point).x  # local point -> global
				min_x = min(min_x, gx)
				max_x = max(max_x, gx)
			return Rect2(min_x, 0, max_x - min_x, 1)
	return Rect2()

### Ran after a bullet was placed correctly.
func new_bullet_inserted() -> void:
	showing_left_bullet = !showing_left_bullet;
	update_sprite();
	$Guncock.play();
	bullet_inserted.emit();

func update_sprite() -> void:
	left_sprite.visible = showing_left_bullet;
	right_sprite.visible = !showing_left_bullet;
