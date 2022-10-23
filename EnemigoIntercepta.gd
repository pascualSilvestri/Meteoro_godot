class_name EnemigoInterceptor
extends NaveBase


var player_objetivo:Player = null
var dir_player:Vector2

func _ready() -> void:
	player_objetivo = DatosJuego.get_player_actual()
	Eventos.connect("nave_destruida",self,"_on_nave_destruidad")

func _physics_process(delta: float) -> void:
		rotar_hacia_jugador()

func _on_nave_destruidad(nave:NaveBase,posicion,explosiones)->void:
	if nave is Player:
		player_objetivo = null


func rotar_hacia_jugador()->void:
	if player_objetivo:
		dir_player = player_objetivo.global_position - global_position
		rotation = dir_player.angle()

func _on_body_entered(body:Node)->void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()


