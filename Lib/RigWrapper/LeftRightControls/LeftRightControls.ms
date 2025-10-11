/** Left right controls
 */
struct LeftRightControls_v
(
	/* construct */
	/* required */
	
	/* properties */
	--obj_L,
	--obj_R,
	
	left,
	right,
	
	lock_position_L,
	lock_rotation_L,

	lock_position_R,
	lock_rotation_R,
		
	/* private */
	controller_types = #( #POSITION, #ROTATION ),
	
	lock_flags = Dictionary #( #POSITION, #{1..3} ) #( #ROTATION, #{4..6} ),
	
	/* dependency */
	/* reference */
	/* inhered */

	/** Add objects
	 */
	function addObjects objs full_basename =
	(
		--format "\n"; print "LeftRightControls_v.addObjects()"
 
		for obj in objs do
			for side in #( "L", "R" ) where matchPattern obj.name pattern:(full_basename + "_"+side+"_*") do 
				case side of
				(
					"L": this.left  = ObjectControllerKeys_v(obj)
					"R": this.right = ObjectControllerKeys_v(obj)
				)

		this --return
	),

	/** Copy keys on times
	 */
	function switchKeysOnTimes phase increment:undefined =
	(
		--format "\n"; print "RigWrapper_v.switchKeysOnTimes()"
		/** Is locked
		 */
		function isLocked flags = flags.count > 0
		
		if increment == undefined then 
			increment = ( phase.end - phase.start ) + 1

		/* GET ONLY KEYS IN PHASE */ 
		keys_L =  left.getKeys #TRANSFORMS phase
		keys_R = right.getKeys #TRANSFORMS phase
		
		keys_all = makeUniqueArray(keys_L + keys_R)
		
		this._setTransformLocks()
			
	
		/* FLIP ORINATATION OF TRANSFROMS */
		
		/* SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT */ 
		
		--this._copyKeysOnTimes left.obj  right.obj keys_L  phase #LEFT
		
		--this._copyKeysOnTimes right.obj left.obj  keys_R phase #RIGHT
		
		keys_pos_L  = left.getKeys #POSITION phase
		keys_pos_R = right.getKeys #POSITION phase
		
		keys_rot_L  = left.getKeys #ROTATION phase
		keys_rot_R = right.getKeys #ROTATION phase
		

		if keys_all.count == 0 then
			return false
		
		format "\n=====================================================\n"
		format "\n"; print "RigWrapper_v.switchKeysOnTimes()"
		format "PHASE:     %\n" phase
		format "INCREMENT: %\n" increment

		--format "left.obj: %\n" left.obj
		--format "right.obj: %\n" right.obj
		
		for source_time in keys_all do
		(
			--format "SOURCE_TIME: %\n" source_time
			target_time = source_time + increment
			
			rot_key_L = findItem keys_rot_L source_time
			rot_key_R = findItem keys_rot_R source_time
			
			pos_key_L = findItem keys_pos_L source_time
			pos_key_R = findItem keys_pos_R source_time
			
			position_keys_exists = pos_key_L or pos_key_R 
			rotation_keys_exists = rot_key_L or rot_key_R 
			--format "position_keys_exists: %\n" position_keys_exists
			--format "rotation_keys_exists: %\n" rotation_keys_exists
			
			mode = case of
			(
				( position_keys_exists and not rotation_keys_exists ): #POSITION
				( rotation_keys_exists and not position_keys_exists ): #ROTATION
				
				default: #BOTH
			)
			
			left_to_right = rot_key_L or pos_key_L
			right_to_left = rot_key_R or pos_key_R
			
			is_pos_locked_L = isLocked lock_position_L
			is_pos_locked_R = isLocked lock_position_R

			is_rot_locked_L = isLocked lock_rotation_L
			is_rot_locked_R = isLocked lock_rotation_R
			

			if ( is_pos_locked_L and is_pos_locked_R ) then
				this.swapLocalRotation source_time target_time mode left_to_right right_to_left
			
			else
				this.flipIKControllers left.obj right.obj source_time target_time mode left_to_right right_to_left
		)
	),
	
	
	private
	

	/* Swap local rotation between two objects, copy at one time, paste at another time
	*/
	function swapLocalRotation time_from time_to mode left_to_right right_to_left =
	(
		--format "\n"; print "TransformFlipper_v.swapLocalRotation()"
		/* 
		Function to set only rotation key on object at given time
		*/
		function setRotationKey obj new_rot _time =
		(
			_time = _time as time
		
			rot_ctrl = obj.rotation.controller
			
			new_key = addNewKey rot_ctrl _time
			
			rot_ctrl.value = new_rot
			-- return
		)
		
		time_from = time_from as time
		time_to   = time_to   as time
		
		obj_L = left.obj
		obj_R = right.obj
		
		--format "time_from: %\n" time_from
		--format "time_to: %\n" time_to
		/* store parents */
		parentA = obj_L.parent
		parentB = obj_R.parent
		
		/* KEEP POS at paste time */
		at time time_to
		(
			pos_L = obj_L.pos
			pos_R = obj_R.pos
			
		)
		
		/* compute local rotations at source time */
		at time time_from
		(
			localRotA = if parentA != undefined then (inverse parentA.rotation * obj_L.rotation) else obj_L.rotation
			localRotB = if parentB != undefined then (inverse parentB.rotation * obj_R.rotation) else obj_R.rotation
		)
		
		/* paste swapped rotations at target time */
		with animate on
		(
			at time time_to
			(
				if left_to_right then
				(
					
					if parentB != undefined then
						obj_R.rotation = parentB.rotation * localRotA
					else
						obj_R.rotation = localRotA
					
		
					obj_R.pos = pos_R
				)
				
				if right_to_left then
				(
					if parentA != undefined then
						obj_L.rotation = parentA.rotation * localRotB
					else
						obj_L.rotation = localRotB
					
					/* RESTORE POS */
					obj_L.pos = pos_L
					
				)
			)
		)
		
		/* remove position keys created on restore position */ 
		left.removeKeys  #POSITION #( time_to.frame as integer )
		right.removeKeys #POSITION #( time_to.frame as integer )
		
	),

	/* 
	Swap IK goal positions of two nodes.
	Works if nodes are IK effectors (like foot controls).
	*/
	function flipIKControllers obj_L obj_R time_from time_to mode left_to_right right_to_left =
	(
		format "\n---------------------------------------"
		format "\n"; print "TransformFlipper_v.flipIKControllers()"
		time_from = time_from as time
		time_to   = time_to   as time		
		format "time_from: %\n" time_from
		format "time_to: %\n" time_to
		
		at time time_from
		(
			pos_L = obj_L.pos
			pos_R = obj_R.pos
	
			rot_L = obj_L.rotation
			rot_R = obj_R.rotation
			
			pos_flipped_L = [-obj_R.pos.x, obj_R.pos.y, obj_R.pos.z]
			pos_flipped_R = [-obj_L.pos.x, obj_L.pos.y, obj_L.pos.z]
		)
		
		with animate on at time time_to
		(
			/* IF ROTATION OR BOTH */ 
			if mode != #POSITION  then
			(
				obj_L.rotation = rot_R
				obj_R.rotation = rot_L
			)
			
			
			/* IF POSITION OR BOTH */ 
			if mode != #ROTATION  then
			(
				obj_L.pos = pos_flipped_L
				obj_R.pos = pos_flipped_R
			)
		)
		
		/* remove keys of unanimated transform -- little dirty, but it works */
		if mode != #BOTH then
		(
			mode_to_delete = if mode == #POSITION  then #ROTATION else #POSITION
	
			left.removeKeys  mode_to_delete time_to.frame
			
			right.removeKeys mode_to_delete time_to.frame
		)
	),


	--/** Copy keys on times
	-- */
	--function _copyKeysOnTimes source_node target_node keys phase side =
	--(
	--	--format "\n"; print "LeftRightControls_v._copyKeysOnTimes()"
	--
	--	--if keys.count > 0 then
	--	(
	--		format "\n-----------------------------------------------------------------\n"
	--		format "\n"; print "LeftRightControls_v._copyKeysOnTimes()"
	--		
	--		format "source_node: %\n" source_node
	--		format "target_node: %\n" target_node
	--		ObjectControllerKeys = getProperty this side
	--		
	--		/* GET SOURCE KEYS */ 
	--		keys_pos  =  ObjectControllerKeys.getKeys #POSITION phase
	--		keys_rot  =  ObjectControllerKeys.getKeys #ROTATION phase
	--		
	--		/* TRANSFORM LOCKS */ 
	--		lock_position = getProperty this ("lock_position_" + side)
	--		lock_rotation = getProperty this ("lock_rotation_" + side)
	--		format "keys_pos: %\n" keys_pos
	--		format "keys_rot: %\n" keys_rot
	--
	--		/* SWAP POSITION OR ROTATION  */ 
	--		mode_bylock = case of
	--		(
	--			( lock_position.count >  0 and lock_rotation.count == 0  ): #ROTATION
	--			( lock_position.count == 0 and lock_rotation.count >  0  ): #POSITION
	--
	--			default: #BOTH
	--		)
	--		format "mode_bylock: %\n" mode_bylock
	--		
	--		for source_time in keys do 
	--		(
	--			format "source_time: %\n" source_time
	--			/* TEST IF KEY ON TRACK EXISTS */ 
	--			has_position = findItem keys_pos source_time > 0
	--			has_rotation = findItem keys_rot source_time > 0
	--			format "has_position: %\n" has_position
	--			format "has_rotation: %\n" has_rotation
	--			mode = case of
	--			(
	--				( mode_bylock == #POSITION and has_position ): #POSITION
	--				( mode_bylock == #ROTATION and has_rotation ): #ROTATION
	--				
	--				( mode_bylock == #BOTH ): if has_position and has_rotation then #BOTH
	--											else if has_position then #POSITION
	--											else if has_rotation then #ROTATION
	--				
	--			)
	--			format "MODE: %\n" mode
	--
	--			/* IF KEYS EXISTS */ 
	--			if mode != undefined then 
	--				this.copyTransformAtTime source_node target_node source_time (source_time + increment) mode:mode
	--		)
	--	)
	--),
	--
	--/* 
	--Function to copy transform data (position, rotation or both) 
	--from one object at given time and apply it to another object at different time 
	--*/
	--function copyTransformAtTime source_node target_node source_time target_time mode:#both =
	--(
	--	format "\n"; print "LeftRightControls_v.copyTransformAtTime()"
	--
	--	/** Swap local rotation
	--	 */
	--	function swapLocalRotation obj_L obj_R source_time =
	--	(
	--		format "\n"; print "LeftRightControls_v.swapLocalRotation()"
	--		
	--		local rot_val
	--		
	--		at time source_time
	--		(
	--			parentA = obj_L.parent
	--			parentB = obj_R.parent
	--			
	--			/* KEEP POS */ 
	--			pos_L = obj_L.pos
	--			pos_R = obj_R.pos
	--			 
	--			/* compute local rotations */ 
	--			localRotA = if parentA != undefined then (inverse parentA.rotation * obj_L.rotation) else obj_L.rotation
	--			localRotB = if parentB != undefined then (inverse parentB.rotation * obj_R.rotation) else obj_R.rotation
	--			
	--			/* swap them */ 
	--			rot_val = if parentA != undefined then
	--				parentA.rotation * localRotB
	--			else
	--				localRotB
	--			
	--			
	--			--rot_val = inverse (parentA.rotation * localRotB)
	--			
	--
	--		)
	--		
	--		rot_val --return
	--	)
	--	
	--	/** Swap position
	--	 */
	--	function swapPosition obj_L obj_R source_time =
	--	(
	--		format "\n"; print "LeftRightControls_v.swapPosition()"
	--		at time source_time
	--			[-obj_L.pos.x, obj_L.pos.y, obj_L.pos.z]
	--	)
	--	
	--	pos_target_node = target_node.pos
	--	
	--	if (isValidNode source_node and isValidNode target_node) then
	--	(
	--		
	--		target_rot = swapLocalRotation source_node target_node source_time 
	--		target_pos = swapPosition      source_node target_node source_time 
	--		
	--		
	--		
	--		--at time source_time
	--		--(
	--		--	src_pos = source_node.position
	--		--	src_rot = source_node.rotation
	--		--)
	--		
	--		at time target_time animate on
	--		(
	--			case mode of
	--			(
	--				#position: ( target_node.position = target_pos )
	--				#rotation: ( target_node.rotation = target_rot )
	--				--#rotation: ( target_node.rotation = target_rot; target_node.pos = pos_target_node )
	--			
	--				#both: 
	--				(
	--					target_node.rotation = target_rot
	--					target_node.position = target_pos
	--				)
	--			)
	--		)
	--	)
	--	-- return
	--),
	
	/** Set transform locks
	 */
	function _setTransformLocks =
	(
		--format "\n"; print "LeftRightControls_v._setTransformLocks()"
		lock_position_L = this.isTransformLocked left.obj #POSITION
		lock_rotation_L = this.isTransformLocked left.obj #ROTATION
		
		--format "lock_position_L: %\n" lock_position_L
		--format "lock_rotation_L: %\n" lock_rotation_L
		lock_position_R = this.isTransformLocked right.obj #POSITION
		lock_rotation_R = this.isTransformLocked right.obj #ROTATION
	),
	
	/** Is transform locked
	  *
	  *
	  * @return array of locked axises
	 */
	function isTransformLocked obj type =
	(
		--format "\n"; print "TransformFlipper_v.isTransformLocked()"
		for i in ((getTransformLockFlags obj) * lock_flags[type] ) collect #( #X, #Y, #Z, #X, #Y, #Z, #X, #Y, #Z )[i]
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "LeftRightControls.onCreate()"
	)

)
