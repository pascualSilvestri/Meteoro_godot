class_name Player
extends RigidBody2D
#atribtos export
export var potencia_motor:int = 5
export var potencia_rotacion: int = 50

#atributos onready
onready var canion: Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D
#Atributosv
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

#Metodos

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("disparo_segundario"):
		laser.set_is_casting(true)
	if event.is_action_released("disparo_segundario"):
		laser.set_is_casting(false)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion*potencia_rotacion)
	
func _process(delta: float) -> void:
	player_input()

func player_input() -> void:
	#empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_frente"):
		empuje = Vector2(potencia_motor,0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor,0)
	
	#rotacion
	dir_rotacion = 0
	if Input.is_action_pressed("mover_derecha"):
		dir_rotacion += 1
	elif Input.is_action_pressed("mover_izquierda"):
		dir_rotacion -= 1
	
	#diparo
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)

