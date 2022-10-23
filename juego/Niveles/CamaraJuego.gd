class_name CamaraJuego
extends Camera2D

var zoom_original:Vector2
var puede_hacer_zoom:bool = true setget set_puede_hacer_zoom

onready var tween_zoom:Tween = $TweenZoom

#setterGetter

func set_puede_hacer_zoom(puede:bool)->void:
	puede_hacer_zoom = puede

func _ready() -> void:
	zoom_original = zoom

func devolver_zoom_original()->void:
	puede_hacer_zoom = false
	zoom_suavidad(zoom_original.x,zoom_original.y,1.0) 
func zoom_suavidad(nuevo_zoom_x:float,nuevo_zoom_y:float,tiempo_transicion:float)->void:
	tween_zoom.interpolate_property(
		self,"zoom",zoom,Vector2(nuevo_zoom_x,nuevo_zoom_y),tiempo_transicion,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)
	tween_zoom.start()

