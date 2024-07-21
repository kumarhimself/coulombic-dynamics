class_name Atom
extends Node2D

@onready var screen_size = get_viewport_rect().size

@export var type = 0
@export var mass = 1
@export var radius = 10
@export var color = Color.BLACK
@export var velocity = Vector2.ZERO


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	queue_redraw()
	screen_wrap()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func screen_wrap():
	position.x = wrapf(position.x, -20, screen_size.x + 20)
	position.y = wrapf(position.y, -20, screen_size.y + 20)
