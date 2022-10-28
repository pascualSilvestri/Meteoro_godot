class_name BaseEnemiga
extends Node2D


export var hitpoints:float = 30.0
export var orbital:PackedScene = null

onready var impacto_SFX:AudioStreamPlayer2D = $AudioStreamPlayer2D

var esta_destruido:bool = false

func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())

func recibir_danio(danio:float)->void:
	hitpoints -= danio
	if hitpoints <= 0 and not esta_destruido:
		esta_destruido = true
		destruir()
	impacto_SFX.play()


func destruir()->void:
	var posision_partes = [
		$Sprites/Sprite.global_position,
		$Sprites/Sprite2.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite4.global_position
	]
	Eventos.emit_signal("base_destruida",posision_partes)
	queue_free()

func elegir_animacion_aleatoria()->String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_aleatoria:int = randi() % num_anim + 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]


func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	
	var new_orbital:EnemigoOrbita = orbital.instance()
	new_orbital.crear(global_position + $PosicionesSpawn/Norte.global_position,self)
	Eventos.emit_signal("spawn_orbital",new_orbital)
