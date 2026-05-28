extends Area2D

var speed = 1000.0
var damage = 25
var shooter = null 

func _ready():
	get_tree().create_timer(2.0).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body == shooter:
		return 
		
	if multiplayer.is_server():
		if body.has_method("rpc_take_damage"):
			body.rpc_take_damage.rpc(damage)
			
	queue_free()
