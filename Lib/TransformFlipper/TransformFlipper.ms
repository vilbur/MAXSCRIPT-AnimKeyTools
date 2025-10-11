/** Rig flipper
 */
struct TransformFlipper_v
(
	/* construct */

	/* required */
	/* properties */

	
	/* private */
	controller_types = #( #POSITION, #ROTATION ),
	
	lock_flags = Dictionary #( #POSITION, #{1..3} ) #( #ROTATION, #{4..6} ),
	/* dependency */
	/* reference */
	/* inhered */
	
	
	/* 
	Process animation keys between two nodes
	*/
	function mirrorTrasformsAtTimes obj_A times_A obj_B times_B =
	(
		format "\n"; print "TransformFlipper_v.mirrorTrasformsAtTimes()"

		format "obj_A: %\n" obj_A
		format "obj_B: %\n" obj_B
		--format "times_A: %\n" times_A
		--format "times_B: %\n" times_B

		lock_position_A = this.isTransformLocked obj_A #POSITION
		lock_rotation_A = this.isTransformLocked obj_A #ROTATION
		format "lock_position_A: %\n" lock_position_A
		format "lock_rotation_A: %\n" lock_rotation_A
		lock_position_B = this.isTransformLocked obj_B #POSITION
		lock_rotation_B = this.isTransformLocked obj_B #ROTATION
		format "lock_position_B: %\n" lock_position_B
		format "lock_rotation_B: %\n" lock_rotation_B
		
		all_times = sort(makeUniqueArray (times_A + times_B))
		--format "all_times: %\n" all_times
		--sort all_times
		
		for _time in all_times do
		(
			format "\n\n===========================================\n"

			format "_time: %\n" _time
			--with animate on
			--at time _time
			(
				sliderTime = _time
				
				for controller_type in controller_types do
				--for controller_type in #( #POSITION ) do
				(
					format "CONTROLLER_TYPE: %\n" controller_type
					--format "\n===========================================\n"
					format "sliderTime: %\n" sliderTime
					key_a = 0
					key_b = 0
					
					ctrl_a = this._getController obj_A controller_type
					format "ctrl_a: %\n" ctrl_a
					ctrl_b = this._getController obj_B controller_type
					
					key_a = this._getKeyIndex ctrl_a ( _time as time ) key_a
					key_b = this._getKeyIndex ctrl_b ( _time as time ) key_b
					format "key_a key index: %\n" key_a
					format "key_b key index: %\n" key_b
					
					if lock_position_A.count == 0 then
					(
						if key_a != undefined and key_b != undefined then
						(
							hasA = key_a > 0
							hasB = key_b > 0
		
							if hasA and hasB then
							(
								this.flipIKControllers obj_A obj_B _time controller_type
	
								--if lock_position_A.count > 0 then
								--	this.swapLocalRotation obj_A obj_B _time
								--else
								--	this.flipIKControllers obj_A obj_B _time
							)
							--else if hasA and not hasB then
							--(
							--	--for controller_type in #( #position, #rotation, #scale ) do
							--		this.swapLocalTransforms obj_A obj_B _time controller_type
							----)
							--else if hasB and not hasA then
							--(
							--	--for controller_type in #( #position, #rotation, #scale ) do
							--		this.swapLocalTransforms obj_B obj_A _time controller_type
							--)
						)
						
					)
					else
						this.swapLocalRotation obj_A obj_B _time

					
					
					
				)
			)
		)
	),
	
	/** Get controller
	 */
	function _getController obj type =
	(
		--format "\n"; print "TransformFlipper_v._getController()"
		case type of
		(
			#POSITION: obj.position.controller
			#ROTATION: obj.rotation.controller
		)
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
	
		
	/* 
	Swap IK goal positions of two nodes.
	Works if nodes are IK effectors (like foot controls).
	*/
	function flipIKControllers obj_A obj_B _time controller_type =
	(
		format "\n---------------------------------------"
		format "\n"; print "TransformFlipper_v.flipIKControllers()"
		_time = _time as time
		with animate on
		at time _time
		(
		  --at time tStart obj.pos.z=loadheight+liftHeight
		--at time tEnd obj.pos.z=loadheight
			--if controller_type == #POSITION then
			(
				temp_pos = obj_A.pos
				obj_A.pos = [-obj_B.pos.x, obj_B.pos.y, obj_B.pos.z]
				obj_B.pos = [-temp_pos.x, temp_pos.y, temp_pos.z]
			)
			--else
			(
				temp_rot = obj_A.rotation
				obj_A.rotation = obj_B.rotation
				obj_B.rotation = temp_rot
			)

		)
	),

	
	/*
	Swap local rotation between two objects
	*/
	function swapLocalRotation obj_A obj_B _time =
	(
		format "\n"; print "TransformFlipper_v.swapLocalRotation()"
		_time = _time as time
	
		with animate on
		at time _time 		
		(
			parentA = obj_A.parent
			parentB = obj_B.parent
			
			/* KEEP POS */ 
			pos_A = obj_A.pos
			pos_B = obj_B.pos
			 
			/* compute local rotations */ 
			localRotA = if parentA != undefined then (inverse parentA.rotation * obj_A.rotation) else obj_A.rotation
			localRotB = if parentB != undefined then (inverse parentB.rotation * obj_B.rotation) else obj_B.rotation
			
			/* swap them */ 
			if parentA != undefined then
				obj_A.rotation = parentA.rotation * localRotB
			else
				obj_A.rotation = localRotB
			
			if parentB != undefined then
				obj_B.rotation = parentB.rotation * localRotA
			else
				obj_B.rotation = localRotA
			
			/* RESORE POS */ 
			obj_A.pos = pos_A
			obj_B.pos = pos_B
				
		)
		-- return
	),

	
	--/* 
	--Swap local transforms of two selected nodes
	--Works for rig controllers (foot, hand, etc.)
	--*/
	--function swapLocalTransforms nodeA nodeB _time controller_type =
	--(
	--	if nodeA != undefined and nodeB != undefined then
	--	(
	--		parentA = nodeA.parent
	--		parentB = nodeB.parent
	--
	--		-- get local transforms
	--		tmA = if parentA != undefined then (nodeA.transform * inverse parentA.transform) else nodeA.transform
	--		tmB = if parentB != undefined then (nodeB.transform * inverse parentB.transform) else nodeB.transform
	--
	--		with animate on at time _time
	--		(
	--			
	--			if parentA != undefined then
	--				nodeA.transform = tmB * parentA.transform
	--			else
	--				nodeA.transform = tmB
	--	
	--				
	--			if parentB != undefined then
	--				nodeB.transform = tmA * parentB.transform
	--			else
	--				nodeB.transform = tmA
	--		)
	--	)
	--),



	private


	/**
	 */
	on create do
	(
		--format "\n"; print "TransformFlipper.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
