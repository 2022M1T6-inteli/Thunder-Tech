extends KinematicBody2D

# Movement Vars
var motionVector: Vector2
var speed = 200
const NORMAL = Vector2(0, -1)

# Jump Vars
var jumpRawForce = 0.0
var jumpRawDir = 0.0

# Movement Funcs
# H_Mov
func MoveHorizontally():
	if is_on_floor():
		motionVector.x = speed * (
			Input.get_action_strength("ui_right") -
			Input.get_action_strength("ui_left"))
#V_Mov
func Gravity():
	var gravPull = 50
	var fallMaxSpeed = 2500
	
	motionVector.y += gravPull
	if motionVector.y > fallMaxSpeed:
		motionVector.y = fallMaxSpeed
func Jump(delta):
	var jumpDir: float
	var timeFactor = 5000
	var jumpForce: float
	var maxForce = 1000
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motionVector.x = 0
			jumpRawForce += timeFactor * delta
			if jumpRawForce > maxForce:
				jumpRawForce = maxForce
			if Input.is_action_just_pressed("ui_right") or Input.is_action_pressed("ui_right"):
				jumpRawDir = speed
			elif Input.is_action_just_pressed("ui_left")  or Input.is_action_pressed("ui_left"):
				jumpRawDir = -speed
		if Input.is_action_just_released("ui_up"):
			jumpForce = jumpRawForce
			jumpDir = jumpRawDir
			jumpRawForce = 0
			jumpRawDir = 0
			#$"../jumpSFX".play()
			motionVector = Vector2(jumpDir, -jumpForce)
func Movement(delta):
	MoveHorizontally()
	Gravity()
	Jump(delta)
	motionVector = move_and_slide(motionVector, NORMAL)


func _physics_process(delta):
	Movement(delta)
