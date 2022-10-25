extends Area2D



func _ready() -> void:
	pass 


func _on_body_entered(body: Node) -> void:
	body.set_gravity_scale(0.1)


func _ona_body_exited(body: Node) -> void:
	body.set_gravity_scale(0.0)
