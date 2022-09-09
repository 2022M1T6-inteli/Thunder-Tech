extends KinematicBody2D

# variables 
export (int) var speed 
var velocity: Vector2
var canDie:bool = false
var directionVector = Vector2.ZERO
var can_attack: bool = false

onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")
onready var collision: CollisionShape2D = get_node("AttackArea/CollisionShape2D")


func _physics_process(_delta:float) -> void:
	move()
	attack()
	animate()
	verifyDirection()
	
func attack() -> void:
	if Input.is_action_just_pressed("select") and not can_attack:
		can_attack = true
	
func move() -> void:
	directionVector = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()
	velocity = speed * directionVector 
	velocity = move_and_slide(velocity)

func animate() -> void: 
	if canDie:
		animation.play("dead")
		set_physics_process(false)
	elif can_attack:
		animation.play("atack")
		set_physics_process(false)
	elif directionVector != Vector2.ZERO:
		animation.play("walk")
	else:
		animation.play("idle")

func verifyDirection() -> void:
	if velocity.x >= 0: 
		sprite.flip_h = false
		collision.position = Vector2(10, 4)
	elif velocity.x < 0: 
		sprite.flip_h = true
		collision.position = Vector2(-10, 4)

func kill() -> void: 
	canDie = true
	
func on_animation_finished(anim_name):
	if anim_name == "dead": 
		var _reload: bool = get_tree().reload_current_scene()
	elif anim_name == "atack":
		can_attack = false
		set_physics_process(true)
