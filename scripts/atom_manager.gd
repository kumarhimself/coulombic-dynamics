extends Node2D

@onready var screen_size : Vector2 = get_viewport_rect().size
const atom_class = preload("res://scenes/atom.tscn")
var atoms_list : Array[Atom] = []
var num_type_atoms : int = 6
var num_atoms : int = 100
var type_atoms_colors : Array[Color] = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.PURPLE]
var force_matrix : Array = []
var min_dist_repulsion : float = 20.0
var max_dist_influence : float = 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_force_matrix()
	spawn_atoms()

func _physics_process(delta) -> void:
	if len(atoms_list) != 0:
		for atom : Atom in atoms_list:
			var net_force : Vector2 = Vector2.ZERO
			for other_atom : Atom in atoms_list:
				if atom != other_atom:
					net_force += calculate_force_linear(atom, other_atom)
			
			atom.velocity += 0.95 * (net_force / atom.mass) * delta
			atom.position += atom.velocity * delta  # Update the position directly

# Initalizes force, min_dist, and max_dist matrices
func initialize_force_matrix() -> void:
	force_matrix.resize(num_type_atoms)
	
	for i : int in range(num_type_atoms):
		force_matrix[i] = []
		for j : int in range(num_type_atoms):
			force_matrix[i].append(max(randf_range(-1, -0.3), randf_range(0.3, 1)))

func spawn_atoms() -> void:
	for i : int in range(num_atoms):
		var atom : Atom = atom_class.instantiate()
		atom.type = randi() % num_type_atoms  # randi_range(0, num_type_atoms)
		atom.color = type_atoms_colors[atom.type]
		atom.position = Vector2(randf() * screen_size.x, randf() * screen_size.y)
		add_child(atom)
		atoms_list.append(atom)
	
func calculate_force_linear(atom : Atom, other_atom : Atom) -> Vector2:
	var total_force : Vector2 = Vector2(0, 0)
	
	var distance : Vector2 = atom.position - other_atom.position
	var distance_magnitude : float = distance.length()
	var direction : Vector2 = distance.normalized()
	
	# If atoms are in the repulsive region, then add a repulsive force
	# so that the atoms do not overlap.
	if distance_magnitude < min_dist_repulsion:
		total_force += direction * 1.5 * abs(force_matrix[atom.type][other_atom.type]) * distance_magnitude / min_dist_repulsion
	
	# If atoms are less than their degree of influence, then apply
	# the primary force.
	if distance_magnitude < max_dist_influence:
		total_force += (-1) * direction * force_matrix[atom.type][other_atom.type] * distance_magnitude / max_dist_influence
	
	return total_force
