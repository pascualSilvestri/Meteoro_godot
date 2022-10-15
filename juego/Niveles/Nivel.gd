class_name Nivel
extends Node2D

onready var contenedor_proyectiles:Node


func _ready() -> void:
	conectar_seniale()
	crear_contenedores()

func conectar_seniale() -> void:
	Eventos.connect("disparo",self,"_on_disparo")

func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name ="ContenedorProye4ctiles"
	add_child(contenedor_proyectiles)


func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)

