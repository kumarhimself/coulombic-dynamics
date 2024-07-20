extends Node2D

var Atom = preload("res://scenes/atom.tscn")
var atoms_list = []
const COULOMB_CONSTANT = 1e6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if len(atoms_list) != 0:
		for atom1 in atoms_list:
			var net_force = Vector2.ZERO
			for atom2 in atoms_list:
				if atom1 != atom2:
					net_force += calculate_force(atom1, atom2)
			
			atom1.atom_velocity += (net_force / atom1.atom_mass) * delta
			atom1.position += atom1.atom_velocity * delta  # Update the position directly
			
			#print("Atom position: ", atom1.position)
			#print("Atom velocity: ", atom1.atom_velocity)
		
func calculate_force(atom1, atom2):
	# Calculating scalar distances and direction from atom1 to atom2
	var distance = atom2.position - atom1.position
	var distance_squared = distance.length_squared()
	var direction = distance.normalized()
	
	if distance_squared < 10:
		return Vector2.ZERO
	
	var force_magnitude = (-1) * COULOMB_CONSTANT * (atom1.atom_charge * atom2.atom_charge) / distance_squared
	
	return direction * force_magnitude

# Checks if user left-clicks mouse, and if so, creates a new atom
# at the mouse location.
func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		var click_position = get_global_mouse_position()
		var atom = Atom.instantiate()
		atom.position = click_position
		atoms_list.append(atom)
		add_child(atom)
		get_viewport().set_input_as_handled()
