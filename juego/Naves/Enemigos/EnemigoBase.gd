class_name EnemigoBase
extends NaveBase

var player_objetivo:Player = null
var dir_player:Vector2
var frame_actual:int = 0

func _ready() -> void:
	player_objetivo = DatosJuego.get_player_actual()
	Eventos.connect("nave_destruida",self,"_on_nave_destruidad")
	Eventos.emit_signal("minimapa_objeto_creado")
	canion.set_esta_disparando(true)

func _physics_process(delta: float) -> void:
	#frame_actual += 1
	#if frame_actual % 3 ==0:
	rotar_hacia_jugador()

func _on_nave_destruidad(nave:NaveBase,_posicion,_explosiones)->void:
	if nave is Player:
		player_objetivo = null
	
	if nave.is_in_group("minimapa"):
		Eventos.emit_signal("minimapa_objeto_destruido",nave)


func rotar_hacia_jugador()->void:
	if player_objetivo:
		dir_player = player_objetivo.global_position - global_position 
		rotation = dir_player.angle()

func _on_body_entered(body:Node)->void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()

