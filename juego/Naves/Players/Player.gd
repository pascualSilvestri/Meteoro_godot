class_name Player
extends RigidBody2D

#enumea
enum ESTADOS {SPAWM,VIVO,INVENCIBLE,MUERTO}
#atribtos export
export var potencia_motor:int = 5
export var potencia_rotacion: int = 50
export var estela_maxima:int=150
#atributos onready
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var canion: Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D setget, get_laser
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var escudo:Escudo = $Escudo setget, get_escudo
	

#Atributos
var estado_actual:int = ESTADOS.SPAWM
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var hitpoints:float = 10.0



#settergetter
func get_laser()->RayoLaser:
	return laser

func get_escudo()->Escudo:
	return escudo

##metodos custom
func controlador_estados(nuevo_estado:int)->void:
	match nuevo_estado:
		ESTADOS.SPAWM:
			colisionador.set_deferred("disabled",true)
			canion.set_puede_disparar(false)
		ESTADOS.VIVO:
			colisionador.set_deferred("disabled",false)
			canion.set_puede_disparar(true)
		ESTADOS.INVENCIBLE:
			colisionador.set_deferred("disabled",true)
		ESTADOS.MUERTO:
			colisionador.set_deferred("disabled",true)
			Eventos.emit_signal("nave_destruida",self,global_position,3)
			canion.set_puede_disparar(false)
			
			queue_free()
		_:
			print('Error de estado')
	estado_actual = nuevo_estado

func destruir()->void:
	controlador_estados(ESTADOS.MUERTO)

func esta_input_activo() ->bool:
	if estado_actual in [ESTADOS.MUERTO,ESTADOS.SPAWM]:
		return false
	return true

#Metodos
func _ready() -> void:
	controlador_estados(estado_actual)


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

func recibir_danio(danio:float)->void:
	hitpoints -= danio
	$impacto.play()
	if hitpoints <= 0.0:
		destruir()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawm":
		controlador_estados(ESTADOS.VIVO)


func _on_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()
