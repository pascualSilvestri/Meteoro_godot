class_name Nivel
extends Node2D

export var explosion:PackedScene = null

onready var contenedor_proyectiles:Node

#metodo custom #metodos
func _ready() -> void:
	conectar_seniale()
	crear_contenedores()

func conectar_seniale() -> void:
	Eventos.connect("disparo",self,"_on_disparo")
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")

func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name ="ContenedorProye4ctiles"
	add_child(contenedor_proyectiles)

func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destruida(posicion:Vector2,num_explosiones:int)->void:
	for i in range(num_explosiones):
		var new_explosion : Node2D = explosion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
		yield(get_tree().create_timer(0.4),"timeout")
