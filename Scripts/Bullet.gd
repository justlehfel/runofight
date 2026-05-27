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
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
