class_name MeteoritoSpawner
extends Position2D

export var direccion:Vector2 = Vector2(1,1)
export var rango_tamanio_meteoro:Vector2 = Vector2(0.5,2.2)

func _ready() -> void:
	yield(owner,"ready")
	spawnear_meteorito()

func spawnear_meteorito()->void:
	Eventos.emit_signal("spawn_meteorito",global_position,direccion,tamanio_meteoro_aleatorio())

func tamanio_meteoro_aleatorio() ->float:
	randomize()
	return rand_range(rango_tamanio_meteoro[0],rango_tamanio_meteoro[1])
