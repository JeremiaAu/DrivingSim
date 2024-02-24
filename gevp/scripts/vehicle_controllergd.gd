extends Node3D

@export var vehicle_node : Vehicle

func _physics_process(delta):
	vehicle_node.brake_input = Input.get_action_strength("Brakes")
	vehicle_node.steering_input = Input.get_action_strength("Steer Left") - Input.get_action_strength("Steer Right")
	vehicle_node.throttle_input = pow(getThrottle(), 2.0)
	vehicle_node.handbrake_input = Input.get_action_strength("Handbrake")
	vehicle_node.clutch_input = clampf(Input.get_action_strength("Clutch") + Input.get_action_strength("Handbrake"), 0.0, 1.0)
	
	if Input.is_action_just_pressed("Toggle Transmission"):
		vehicle_node.automatic_transmission = !vehicle_node.automatic_transmission
	
	if Input.is_action_just_pressed("Shift Up"):
		vehicle_node.manual_shift(1)
	
	if Input.is_action_just_pressed("Shift Down"):
		vehicle_node.manual_shift(-1)
	
	if vehicle_node.current_gear == -1:
		vehicle_node.brake_input = getThrottle()
		vehicle_node.throttle_input = Input.get_action_strength("Brakes")
	
var throttleControllerHasBeenUsed = false
func getThrottle():
	var keyboardInput = Input.get_action_strength("Throttle")
	if keyboardInput == 1:
		return keyboardInput
	
	var controllerInputUpperUnmodified = Input.get_action_strength("ThrottleUpperHalfInverse")
	
	if controllerInputUpperUnmodified != 0:
		throttleControllerHasBeenUsed = true
	
	var controllerInputUpper = (controllerInputUpperUnmodified * -1) + 1
	if !throttleControllerHasBeenUsed:
		controllerInputUpper = 0
		
	var controllerInputLower = Input.get_action_strength("ThrottleLowerHalf")
	var controllerInput = (controllerInputUpper + controllerInputLower) / 2
	
	print_debug("ThrottleUpper: " + str(controllerInputUpper))
	print_debug("ThrottleLower: " + str(controllerInputLower))
	print_debug("Throttle: " + str(controllerInput))
	
	return controllerInput
	
