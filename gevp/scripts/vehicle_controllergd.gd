extends Node3D

@export var vehicle_node : Vehicle

func _physics_process(_delta):
	vehicle_node.brake_input = getBrakes()
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
		vehicle_node.throttle_input = getBrakes()
	
var throttleControllerHasBeenUsed = false
func getThrottle():
	var keyboardInput = Input.get_action_strength("Throttle")
	if keyboardInput == 1:
		return keyboardInput
	
	var ThrottleAxis = Input.get_axis("ThrottleLowerAxis", "ThrottleUpperAxis")
	
	if ThrottleAxis != 0:
		throttleControllerHasBeenUsed = true
	
	if !throttleControllerHasBeenUsed:
		return 0
	else:
		return (ThrottleAxis * -1 + 1) / 2
		
var brakeControllerHasBeenUsed = false
func getBrakes():
	var keyboardInput = Input.get_action_strength("Brakes")
	if keyboardInput == 1:
		return keyboardInput
	
	var BrakeAxis = Input.get_axis("BrakesLowerAxis", "BrakesUpperAxis")
	
	if BrakeAxis != 0:
		brakeControllerHasBeenUsed = true
	
	if !brakeControllerHasBeenUsed:
		return 0
	else:
		return (BrakeAxis * -1 + 1) / 2
	
