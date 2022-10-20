class_name Meteorito
extends RigidBody2D

export var vel_lineal_base:Vector2 = Vector2(300.0,300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base:float = 10.0

var hitspoints:float
#metodos
onready var impacto_SFX: AudioStreamPlayer2D = $AudioStreamPlayer2D
func _ready() -> void:
	angular_velocity = vel_ang_base

#contructor
func crear(pos:Vector2,dir:Vector2,tamanio:float)->void:
	position = pos
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	var radio:int = int($Sprite.texture.get_size().x /2.3 *tamanio)
	var form_colision:CircleShape2D = CircleShape2D.new()
	form_colision.radius= radio
	$CollisionShape2D.shape = form_colision
	linear_velocity = (vel_lineal_base * dir / tamanio)* aleatorizar_velocidad()
	angular_velocity = (vel_ang_base / tamanio)* aleatorizar_velocidad()
	hitspoints = hitpoints_base * tamanio

func aleatorizar_velocidad() -> float:
	randomize()
	return rand_range(1.1,1.6)



func recibir_danio(danio:float)->void:
	hitspoints -= danio
	if hitspoints <= 0:
		destruir()
	impacto_SFX.play()
	$AnimationPlayer.play("impacto")


func destruir()->void:
	$CollisionShape2D.set_deferred("disabled",true)
	Eventos.emit_signal("meteorito_destruido",global_position)
	queue_free()

