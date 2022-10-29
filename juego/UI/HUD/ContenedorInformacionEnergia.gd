class_name ContenedorInformacionEnergia
extends "res://juego/UI/HUD/ContenedorInformacion.gd"

onready var medidor:ProgressBar = $ProgressBar

func _ready() -> void:
	pass 



func actualizar_energia(energia_max:float,energia_actual:float)->void:
	var energia_porcentual:int = (energia_actual*100) / energia_max
	medidor.value = energia_porcentual
