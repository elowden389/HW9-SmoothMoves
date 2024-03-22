extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?
# The above exported variables control the character's movement values. 
# By exporting them it allows us to change the values for each individual character without making a new script.


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100)  # Gives the character gravity as soon as the scene starts.
	pass # Replace with function body.


func _get_input():            # Creating a function, _get_input, to tell when a character is on a floor or in air.
	if is_on_floor():
		if Input.is_action_pressed("move_left"):     # If the character is on the floor and presses the A key to move left,
			velocity += Vector2(-movement_speed,0)   # They will move left. The minus sign for movement_speed var is necessary
													 # To move the character to the left instead of the right.
		if Input.is_action_pressed("move_right"):    # Same as moving left but for using the D key to move right.
			velocity += Vector2(movement_speed,0)    # Movement right is in the positive X axis direction so there's no minus sign.

		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height)  # Character jumps when the spacebar is pressed.

	if not is_on_floor():
		if Input.is_action_pressed("move_left"):     # If the character is not on the floor we want their horizontal movement to be affected,
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)  # So the movement speed value is multiplied by a coefficient,
																				 # Allowing for both faster and slower in air speed based on the coefficient's value
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)
# Using variables in the above functions instead of constant values allows for the script to be changed on the fly
# for individual characters. Also makes the code a lot easier to read.

func _limit_speed():          # Creating a function to set a cap to the speed a character can travel.
	if velocity.x > speed_limit:
		velocity = Vector2(speed_limit, velocity.y)  # If the character's speed goes over the cap, 
													 # then this set the speed back to the cap
	if velocity.x < -speed_limit:                    # Since our leftwards movement is based on negative values,
		velocity = Vector2(-speed_limit, velocity.y) # we need a negative speed cap aswell to cap leftwards movement.

func _apply_friction():       # Creating a function to apply friction to the character. 
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")): # This line makes sure character is only affected by friction when they are staionary on the floor.
		velocity -= Vector2(velocity.x * friction, 0) #Subtracts the velocity when affected by friction from the character's current velocity and sets it equal to that value.
		if abs(velocity.x) < 5:               # This line looks for the absolute value of velocity so that both left and right movement is affected
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

func _apply_gravity():        # Creating a function to apply gravity to the character.
	if not is_on_floor():     # Only affects the character when they are in the air.
		velocity += gravity   # Adds gravity to the character's velocity and sets velocity to that value.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): # This function is necessary to make sure the game is continually looking for all the above functions. If these functions weren't called every frame the game would break.
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide()
	pass
