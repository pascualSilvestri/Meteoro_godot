class_name Player
extends NaveBase

#atribtos export
export var potencia_motor:int = 18
export var potencia_rotacion: int = 50
export var estela_maxima:int=150

onready var laser:RayoLaser = $LaserBeam2D setget, get_laser
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var escudo:Escudo = $Escudo setget, get_escudo


var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

#settergetter
func get_laser()->RayoLaser:
	return laser

func get_escudo()->Escudo:
	return escudo

func _ready() -> void:
	DatosJuego.set_player_actual(self)

func _unhandled_input(event: InputEvent) -> void:
	#disparo segundario
	if not esta_input_activo():
		return 
	if event.is_action_pressed("disparo_segundario"):
		laser.set_is_casting(true)
	if event.is_action_released("disparo_segundario"):
		laser.set_is_casting(false)
	#control estela y sonido
	if event.is_action_pressed("mover_frente"):
		estela.set_max_points(estela_maxima)
		motor_sfx.sonido_on()

	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
		motor_sfx.sonido_on()
	#control de escudo
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado(escudo.esta_activado):
		escudo.activar()
	

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion*potencia_rotacion)
	
func _process(delta: float) -> void:
	player_input()

func player_input() -> void:
	if not esta_input_activo():
		return 
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

func esta_input_activo() ->bool:
	if estado_actual in [ESTADOS.MUERTO,ESTADOS.SPAWM]:
		return false
	return true


func desactivar_controles()->void:
	controlador_estados(ESTADOS.SPAWM)
	empuje = Vector2.ZERO
	motor_sfx.sonido_off()
	laser.set_is_casting(false)
