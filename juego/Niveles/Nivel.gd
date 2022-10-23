class_name Nivel
extends Node2D

export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explocion_meteorito: PackedScene = null
export var sector_meteoritos:PackedScene = null
export var enemigo_interceptor:PackedScene = null
export var tiempo_transicion_camara:float = 0.7

onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node
onready var contenedor_sector_meteoritos:Node
onready var camara_nivel:Camera2D = $CameraNivel
onready var contenedor_enemigo:Node

var meteoritos_totales:int = 0
var player:Player = null

#metodo custom #metodos
func _ready() -> void:
	conectar_seniale()
	crear_contenedores()
	player = DatosJuego.get_player_actual()

func conectar_seniale() -> void:
	Eventos.connect("disparo",self,"_on_disparo")
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")
	Eventos.connect("spawn_meteorito",self,"_on_spawn_meteoritos")
	Eventos.connect("meteorito_destruido",self,"_on_meteorito_destruido")
	Eventos.connect("nave_en_sector_peligro",self,"_on_nave_en_sector_peligro")

func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name ="ContenedorProye4ctiles"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)
	
	contenedor_sector_meteoritos = Node.new()
	contenedor_sector_meteoritos.name = "ContenedorSectorMeteoritos"
	add_child(contenedor_sector_meteoritos)
	
	contenedor_enemigo = Node.new()
	contenedor_enemigo.name = "ContenedorEnemigo"
	add_child(contenedor_enemigo)

func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destruida(nave:Player, posicion:Vector2,num_explosiones:int)->void:
	if nave is Player:
		transicion_camara(
			posicion,
			posicion + crear_posicion_aleatoria(-200.0,200.0),
			camara_nivel,
			tiempo_transicion_camara
		)
	
	for i in range(num_explosiones):
		var new_explosion : Node2D = explosion.instance()
		new_explosion.global_position = posicion + crear_posicion_aleatoria(100.0,50.0)
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6),"timeout")

func _on_spawn_meteoritos(pos_spawn:Vector2,dir_meteorito:Vector2,tamanio:float) ->void:
	var new_meteorito : Meteorito = meteorito.instance()
	new_meteorito.crear(pos_spawn,dir_meteorito,tamanio)
	contenedor_meteoritos.add_child(new_meteorito)

func _on_meteorito_destruido(pos:Vector2)->void:
	var new_explosion:ExplosionMeteorito = explocion_meteorito.instance()
	new_explosion.global_position = pos
	add_child(new_explosion)
	
	controlar_meteoritos_restantes()


func _on_nave_en_sector_peligro(centro_cam:Vector2,tipo_peligro:String,num_peligro:int)->void:
	if tipo_peligro == "Meteorite":
		crear_sector_meteoritos(centro_cam,num_peligro)
	elif tipo_peligro == "Enemy":
		crear_sector_enemigo(num_peligro)

func crear_sector_meteoritos(centro_cam:Vector2,num_peligro:int)->void:
	meteoritos_totales = num_peligro
	var new_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.crear(centro_cam,num_peligro)
	camara_nivel.global_position = centro_cam
	contenedor_sector_meteoritos.add_child(new_sector_meteoritos)
	camara_nivel.zoom = $Player/CameraPlayer.zoom
	camara_nivel.devolver_zoom_original()
	transicion_camara(
		$Player/CameraPlayer.global_position,
		camara_nivel.global_position,
		camara_nivel,
		tiempo_transicion_camara
	)
	
func controlar_meteoritos_restantes()->void:
	meteoritos_totales -= 1
	print(meteoritos_totales)
	if meteoritos_totales == 0:
		contenedor_sector_meteoritos.get_child(0).queue_free()
		$Player/CameraPlayer.set_puede_hacer_zoom(true)
		var zoom_actual = $Player/CameraPlayer.zoom
		$Player/CameraPlayer.zoom = camara_nivel.zoom
		$Player/CameraPlayer.zoom_suavidad(zoom_actual.x,zoom_actual.y,1.0)
		transicion_camara(
			camara_nivel.global_position,
			$Player/CameraPlayer.global_position,
			$Player/CameraPlayer,tiempo_transicion_camara*0.10
		)

func crear_sector_enemigo(num_enemigo)->void:
	for i in range(num_enemigo):
		var new_interceptor:EnemigoInterceptor = enemigo_interceptor.instance()
		var spawn_pos:Vector2 = crear_posicion_aleatoria(1000.0,800.0)
		new_interceptor.global_position = player.global_position +spawn_pos
		contenedor_enemigo.add_child(new_interceptor)
	

func transicion_camara(desde:Vector2,hasta:Vector2,camara_actual:Camera2D,tiempo_transicion:float)->void:
	$TweenCamara.interpolate_property(
		camara_actual,"global_position",
		desde,
		hasta,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camara_actual.current = true
	$TweenCamara.start()


func crear_posicion_aleatoria(rango_horizontal:float,rango_vertical:float)->Vector2:
	randomize()
	var rand_x = rand_range(-rango_horizontal,rango_horizontal)
	var rand_y = rand_range(-rango_vertical,rango_vertical)
	return Vector2(rand_x,rand_y)
	

func _on_TweenCamara_tween_completed(object: Object, key: NodePath) -> void:
	if object.name == "CamaraPlayer":
		object.global_position = $Player.global_position
