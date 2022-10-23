class_name SectorMeteoritos
extends Node2D

export var cantidad_meteoritos:int = 10
export var intervalo_spawn:float = 1.2

var spawners:Array


#constructor
func crear(pos:Vector2,meteorito:int)->void:
	global_position = pos
	cantidad_meteoritos = meteorito


#metodos

func _ready() -> void:
	$SpawnTimer.wait_time = intervalo_spawn
	almacenar_spawners()
	$AnimationPlayer.play("advertencias")

func almacenar_spawners()->void:
	for spawner in $spawners.get_children():
		spawners.append(spawner) 

func spawner_aleatorio()->int:
	randomize()
	return randi() % spawners.size()

func conectar_seniales_detectores() -> void:
	for detector in $DetectorFueraZona.get_children():
		detector.connect("body_entered",self,"_on_detector_body_entered")



func _on_SpawnTimer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$SpawnTimer.stop()
		return
	
	spawners[spawner_aleatorio()].spawnear_meteorito()
	cantidad_meteoritos -=1


func _on_detector_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)


func _on_DetectorDerecho_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)


func _on_DetectorSuperior_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)


func _on_DetectorInferior_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)
