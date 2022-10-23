class_name EnemigoInterceptor
extends "res://juego/Naves/NaveBase.gd"




func _ready() -> void:
	canion.set_esta_disparando(true)


func _on_body_entered(body:Node)->void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()
