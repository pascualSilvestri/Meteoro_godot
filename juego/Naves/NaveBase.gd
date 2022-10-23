class_name NaveBase
extends RigidBody2D

#enumea
enum ESTADOS {SPAWM,VIVO,INVENCIBLE,MUERTO}

export var hitpoints:float = 20.0

#atributos onready
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var canion: Canion = $Canion


#Atributos
var estado_actual:int = ESTADOS.SPAWM





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

#Metodos
func _ready() -> void:
	controlador_estados(estado_actual)

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
