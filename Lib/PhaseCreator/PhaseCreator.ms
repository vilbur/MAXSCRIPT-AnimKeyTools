/** Trasforms on time manager
 */
struct PhaseCreator_v
(

	
	/** Repeat phase
	 */
	function repeatPhaseTransform objs =
	(
		format "\n"; print "PhaseCreator_v.repeatPhase()"
		
		current_time = currentTime.frame as integer
		
		for obj in objs do
		(
			--format "obj: %\n" obj
			ControllerKeys = ObjectControllerKeys_v(obj)
			
			--format "ControllerKeys.getKeys #TRANSFORMS: %\n" (ControllerKeys.getKeys #TRANSFORMS undefined ) 
			keys_transforms = ControllerKeys.getKeys #TRANSFORMS undefined

			/* IF KEY EXIST ON TIME */ 			
			if keys_transforms.count > 0 and ( index = findItem keys_transforms current_time ) > 1 then
			(
				key_prev     = keys_transforms[index - 1]
				key_current  = keys_transforms[index]
				format "key_prev:    %\n" key_prev
				format "key_current: %\n" key_current
				phase_length = key_current - key_prev
				key_next = key_current + phase_length
					
				--for prop in #( #POSITION, #ROTATION )
				for prop in #( #POSITION, #ROTATION, #SCALE )
					where ControllerKeys.keyExists prop key_current do
					(
						--format "PROP: %\n" prop
						val_prev    = at time key_prev    ( getProperty obj prop)
						val_current = at time key_current ( getProperty obj prop)
						
						val_between_keys = val_current - val_prev
						--format "VAL_BETWEEN_KEYS: %\n" val_between_keys
						/* ADD NEW KEY */ 
						with animate on at time key_next
							setProperty obj prop ( val_current + val_between_keys )
					)
					
			)
			else
				messageBox ( obj.name + " has not transform key on TIME: " +current_time as string ) title:"ANIM KEY NOT FOURND"  beep:false
		)
	),
	
	
	private
	

	
	
	/** Get object
	 */
	function getObject full_basename side =
	(
		--format "\n"; print "PhaseCreator_v.getObject()"
		objs_by_name = execute ("$'"+ full_basename + "_" + side + "_*'") 
		
		objs_by_name[1] --return
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "PhaseCreator.onCreate()"
	)
)
