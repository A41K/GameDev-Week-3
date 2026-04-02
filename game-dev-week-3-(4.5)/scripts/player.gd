class_name Player extends CharacterBody2D

@onready var CoyoteTimer: Timer = $CoyoteTimer
@onready var JumpBufferTimer: Timer = $JumpBufferTimer

var coyote_time_activated: bool = false

const jump_height: float = -400.0
var gravity: float = 20.0
const max_gravity: float = 18

const max_speed: float = 300
const acceleration: float = 16
const friction: float = 20

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight: float = delta * (acceleration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if is_on_floor():
		coyote_time_activated = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	else:
		if CoyoteTimer.is_stopped() and !coyote_time_activated:
			CoyoteTimer.start()
			coyote_time_activated = true
		
		if Input.is_action_just_released("jump") or is_on_ceiling():
			velocity.y *= 0.5
		
		gravity = lerp(gravity, max_gravity, 12.0 * delta)
		
	if Input.is_action_just_pressed("jump"):
		if JumpBufferTimer.is_stopped():
			JumpBufferTimer.start()
			
	if !JumpBufferTimer.is_stopped() and (!CoyoteTimer.is_stopped() or is_on_floor()):
		velocity.y = jump_height
		JumpBufferTimer.stop()
		CoyoteTimer.stop()
		coyote_time_activated = true
		
	if velocity.y < jump_height/2.0:
		var head_collision: Array = [$Left_HeadNudge.is_colliding(), $Left_HeadNudge2.is_colliding(), $Right_HeadNudge.is_colliding(), $Right_HeadNudge2.is_colliding()]
		if head_collision.count(true) == 1:
			if head_collision[0]:
				global_position.x += 1.75
			if head_collision[2]:
				global_position.x -= 1.75
	
	if velocity.y > -30 and velocity.x < -5 and abs(velocity.x) > 3:
		if $Left_LedgeHop.is_colliding() and !$Left_LedgeHop2.is_colliding() and velocity.x < 0:
			velocity.y += jump_height/3.25
		if $Right_LedgeHop.is_colliding() and !$Right_LedgeHop2.is_colliding() and velocity.x > 0:
			velocity.y += jump_height/3.25
	
	velocity.y += gravity
	
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_spike_2_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_flag_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
