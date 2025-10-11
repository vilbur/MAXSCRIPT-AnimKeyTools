/** Walk cycle animator
 */
struct WalkCycleAnimator_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	

	/** Animate walk on rig
	 */
	function animateWalkOnRig rig_name steps_count keys_per_step step_length: =
	(
		format "\n"; print ".animateWalkOnRig()"
		--format "DIALOG_t_anim_key_tools.DL_rig.items: %\n" DIALOG_t_anim_key_tools.DL_rig.items
		--format "DIALOG_t_anim_key_tools.DL_rig.selected: %\n" DIALOG_t_anim_key_tools.DL_rig.selected
		--rig_name = DIALOG_t_anim_key_tools.DL_rig.selected
		format "rig_name: %\n" rig_name
		
		
		steps_count	= steps_count as integer
		--step_length	= step_length as integer
		keys_per_step	= keys_per_step as Number
		format "steps_count: %\n" steps_count
		format "step_length: %\n" step_length
		format "keys_per_step: %\n" keys_per_step
		RigWrapper = RigWrapper_v()
		
		master_ctrl = ( RigWrapper.getControlObject rig_name "MasterWalk" )[1]
		
		foot_left  = ( RigWrapper.getControlObject rig_name "IKFoot_L" )[1]
		foot_right = ( RigWrapper.getControlObject rig_name "IKFoot_R" )[1]
		
		
		distance_of_feet = this._getDistanceOnYaxis foot_left foot_right
		
		if distance_of_feet > 0.1 then
			step_length = distance_of_feet
		
		
		format "master_ctrl: %\n" master_ctrl
		format "foot_left: %\n" foot_left
		format "foot_right: %\n" foot_right
		format "distance_of_feet: %\n" distance_of_feet
					--rig_controllers = execute ("$'*_Setup_Ctrl_*'") as Array
		this.animateWalkCycle master_ctrl foot_left foot_right steps_count step_length keys_per_step
	),
	
	
	/* 
	Function to animate walk cycle of two foot controls and one master control.
	User specifies number of keys per step, step length, and steps count.
	Animates only first and last key of the step.
	*/
	function animateWalkCycle master_ctrl left_foot right_foot steps_count step_length keys_per_step =
	(
		format "\n"; print "WalkCycleAnimator_v.animateWalkCycle()"
		format "step_length: %\n" step_length
		
		if (isValidNode master_ctrl and isValidNode left_foot and isValidNode right_foot) then
		(
			
			time_start = currentTime.frame as integer
			format "TIME_START: %\n" time_start
			format "master_ctrl.pos: %\n" master_ctrl.pos
			
			format "master_ctrl.pos.y: %\n" master_ctrl.pos.y
			
			master_ctrl_pos = master_ctrl.pos

			master_ctrl.pos = [0,0,0]
			
			(KeyFrameManager_v()).removeKeys objs:master_ctrl time:[ time_start + 1, time_start + ( steps_count * keys_per_step ) ]

			
			
			which_foot_is_front  = if left_foot.pos.y < right_foot.pos.y then #LEFT else #RIGHT
			which_foot_is_moving = if left_foot.pos.y > right_foot.pos.y then #LEFT else #RIGHT
			format "WHICH_FOOT_IS_MOVING: %\n" which_foot_is_moving
			
			
			animate on
			(
				current_time = time_start
				step_time = keys_per_step
				
				half_step = step_length / 2.0
				
				foot_front = if which_foot_is_front == #LEFT then left_foot.pos.y else right_foot.pos.y
				foot_back  = if which_foot_is_front != #LEFT then left_foot.pos.y else right_foot.pos.y
				
				
				format "foot_front: %\n" foot_front
				format "foot_back: %\n" foot_back
				
				
				
				
				--for i = 2 to steps_count do
				--(
				--	current_time += step_time
				--	format "STEP: % current_time: %\n" i current_time
				--	
				--	
				--	if which_foot_is_moving == #LEFT then
				--	(
				--		at time ( current_time ) left_foot.pos.y = foot_front
				--		
				--		at time ( current_time ) right_foot.pos.y = foot_back
				--	)
				--	else
				--	(
				--		at time ( current_time ) right_foot.pos.y = foot_front
				--		
				--		at time ( current_time ) left_foot.pos.y = foot_back
				--	)
				--	
				--	which_foot_is_moving = if which_foot_is_moving == #RIGHT then #LEFT else #RIGHT
				--	
				--)
				

				
			)
			
			master_ctrl.pos = master_ctrl_pos

			current_time = time_start
			format "current_time: %\n" current_time
		
				--master_ctrl.pos = master_ctrl_pos
			animate on
			(
				pos = master_ctrl.pos.y --+ step_length
				
				for i = 1 to steps_count + 1 do
				(
					format "%: %\n" current_time pos
					at time (current_time) master_ctrl.pos.y = pos
					
					pos -= step_length 
					
					current_time += step_time
				)
			
				
			)

			
			
			
			
		) -- return
	),
	
	private
	
	/** Get distance on yaxis
	 */
	function _getDistanceOnYaxis obj_A obj_B =
	(
		--format "\n"; print "WalkCycleAnimator_v._getDistanceOnYaxis()"
		distance [ 0, obj_A.pos.y, 0] [ 0, obj_B.pos.y, 0] --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "WalkCycleAnimator.onCreate()"
	)
)

