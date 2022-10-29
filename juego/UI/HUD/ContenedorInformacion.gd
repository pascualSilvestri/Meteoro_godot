class_name ContenedorInformacion
extends NinePatchRect

export var auto_ocultar:bool = false

onready var text_contenedor:Label = $Label
onready var auto_ocultar_timer:Timer = $AutoOcultarTimer
onready var animaciones:AnimationPlayer= $AnimationPlayer

var esta_activo:bool = true setget set_esta_activo 


#settergetter

func set_esta_activo(valor:bool)->void:
	esta_activo = valor



func mostrar()->void:
	if esta_activo:
		$AnimationPlayer.play("mostrar")

func mostrar_suavizado()->void:
	if not esta_activo:
		return
	$AnimationPlayer.play("mostrar_suavisado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar()->void:
	if not esta_activo:
		animaciones.stop()
	$AnimationPlayer.play("ocultar")

func ocultar_suavizado()->void:
	if esta_activo:
		$AnimationPlayer.play("ocultar_suavisado")


func modificar_Texto(text:String)->void:
	text_contenedor.text = text


func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavizado()
