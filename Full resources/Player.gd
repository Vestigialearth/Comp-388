extends KinematicBody2D

const SPEED = 60
const GRAVITY = 9.8
const JUMP_POWER = -250
const PLASMABALL = preload("res://Plasmaball.tscn")

var FLOOR = Vector2(0 , -1)
var velocity = Vector2()
var on_ground = false
var is_attacking = false
var is_dead = false

func _process(delta):
	if is_dead == false: 
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = SPEED
				if is_attacking == false:
					$AnimatedSprite.play("Run")
					$AnimatedSprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
				
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = -SPEED
				if is_attacking == false:
					$AnimatedSprite.play("Run")
					$AnimatedSprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
				
		else:
			velocity.x = 0 
			if on_ground == true:
				$AnimatedSprite.play("Idle")
	
			
		if Input.is_action_pressed("ui_up"):
			if on_ground == true:
				velocity.y = JUMP_POWER
			on_ground = false 
	
		if Input.is_action_just_pressed("ui_accept") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
	#		$AnimatedSprite.play("Attack")
			var plasmaball = PLASMABALL.instance()
			if sign($Position2D.position.x) == 1:
				plasmaball.set_plasmaball_direction(1)
			else:
				plasmaball.set_plasmaball_direction(-1)
			get_parent().add_child(plasmaball)
			plasmaball.position = $Position2D.global_position
		
		velocity.y += GRAVITY
			
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
			
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "EnemyT1" in get_slide_collision(i).collider.name:
					dead()
func dead():
	is_dead = true
	velocity = Vector2(0 , 0)
	$AnimatedSprite.play("Dead")
	$CollisionShape2D.disabled = true
	$Timer.start()

func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")
