extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -300.0
@export var jump_count = 1
@export var player_health = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

	
	
func _physics_process(delta):
	if player_health <= 0:
		get_tree().change_scene_to_file("res://death.tscn")
	
	if not is_on_floor():
		velocity.y += gravity * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and jump_count > 0:
		jump_count -= 1
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		
	if is_on_floor():
		jump_count = 1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false
		
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("run")
		
	else:
		if velocity.y == 0:
			anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.y > 0:
		anim.play("fall")

	move_and_slide()


func _on_quit_pressed():
	
	get_tree().quit()




func _on_area_2d_body_entered(body):
	print("hit")
	player_health = 0
