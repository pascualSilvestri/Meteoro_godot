class_name Escudo
extends Area2D

export var energia:float = 8.0
export var radio_desgastes:float = -1.6

var esta_activado:bool = false setget get_esta_activado
var energia_original:float

func _ready() -> void:
	energia_original = energia	
	set_process(false)
	controlar_colisionador(true)

func _process(delta: float) -> void:
	controlar_energia(radio_desgastes * delta)

func controlar_energia(consumo:float)->void:
	energia += consumo
	
	if energia > energia_original:
		energia = energia_original
	elif energia <= 0.0:
		Eventos.emit_signal("ocultar_energia_escudo")
		desactivar()
		return
	Eventos.emit_signal("ocultar_energia_escudo",energia_original,energia)












func desactivar()->void:
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	$AnimationPlayer.play_backwards("activandose")

func get_esta_activado(esta_activado:bool) -> bool:
	return esta_activado
#metodos custon
func controlar_colisionador(esta_desactivado:bool)->void:
	$CollisionShape2D.set_deferred("disabled",esta_desactivado)

func activar()->void:
	
	if energia <= 0.0:
		return
	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("activandose")


#señales internas

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activandose" and esta_activado:
		$AnimationPlayer.play("activada")
		set_process(true)





func _on_body_entered(body: Node) -> void:
	body.queue_free()
