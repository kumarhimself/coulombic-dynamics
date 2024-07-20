extends Node2D

@export var atom_charge = -2
@export var atom_mass = 15.9 # AMU
@export var atom_radius = 10
@export var atom_color = Color.BLACK
var atom_velocity = Vector2.ZERO

@onready var screen_size = get_viewport_rect().size


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	screen_wrap()

func _draw():
	draw_circle(Vector2.ZERO, atom_radius, atom_color)

func screen_wrap():
	position.x = wrapf(position.x, -20, screen_size.x + 20)
	position.y = wrapf(position.y, -20, screen_size.y + 20)
