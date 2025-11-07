


/*==============================================================================

		BUTTONS

================================================================================*/

/** Get cycle range
 */
function getCycleRange =
(
	--format "\n"; print ".getCycleRange()"
	phase = getPhaseRange()
	
	cycle = copy phase
	
	cycle.y += cycle.y - cycle.x + 1
	
	cycle --return
)

/** Create or mirro phase
 */
function createOrMirroPhase mode =
(
	--format "\n"; print ".createOrMirroPhase()"
	
	/** Get phase - nuber of frames before current time
		
		[phase keys][currentTime]
		
		@return Point2 [ start time, end time ]
	  
	 */
	function getPhaseRange dir:#BACKWARD  =
	(
		--format "\n"; print ".getPhaseRange()"
		
		current_time = currentTime.frame as integer 
		phase_length = ROLLOUT_phasemaker_options.DL_phase_length.selected as integer
		
		phase = [ current_time as integer , current_time as integer ] --return
		
		if dir == #BACKWARD then
		(
			phase.x = current_time - phase_length + 1
			
			--phase.y -= 1
		)
		else
			phase.y = current_time + phase_length - 1
	
		phase --return
	)
	
	increment = ROLLOUT_phasemaker_options.DL_increment_value.selected as integer
	
	rig_name = ROLLOUT_phasemaker_options.DL_rig_select.selected
	
	phase = getPhaseRange dir:( if mode == #CREATE then #FORWARD else #BACKWARD )
	--format "PHASE: %\n" phase

	if (trimLeft(rig_name)).count > 0 then
		(RigWrapper_v(rig_name)).mirrorPhase phase increment:increment

	--else
		--(KeyFrameManager_v()).copyKeys time:phase transforms:true properties:false -- default increment is length ofrange + 1
	
	
)


/**  
 */
macroscript	template_phase_create
category:	"_AnimKeyTools"
--buttontext:	"Frame - > Phase"
buttontext:	"C R E A T E phase"
toolTip:	""
icon:	"across:1|id:#BTN_create_phase|width:128|height:32|border:false"
(
	--format "EventFired: %\n" EventFired
	undo "Create Phase" on
		createOrMirroPhase #CREATE
)


/**  
 */
macroscript	template_mirror_phase
category:	"_AnimKeyTools"
--buttontext:	"Frame - > Phase"
buttontext:	"M I R R O R phase"
toolTip:	""
icon:	"across:1|id:#BTN_mirror_phase|width:128|height:32|border:false|align:#CENTER"
(
	undo "Mirror Phase" on
		createOrMirroPhase #MIRROR
)

/**  
 */
macroscript	template_copy_phase
category:	"_AnimKeyTools"
--buttontext:	"Frame - > Phase"
buttontext:	"C O P Y phase \ cycle"
toolTip:	"Copy phase"
icon:	"across:1|width:128|height:32|border:false"
(
	undo "Copy phase" on
		(KeyFrameManager_v( getPhaseRange() )).copyKeys objs:( selection as Array )
)
/**  
 */
macroscript	template_copy_cycle
category:	"_AnimKeyTools"
--buttontext:	"Frame - > Phase"
buttontext:	"C O P Y phase \ cycle"
toolTip:	"Copy cycle - 1 cycle == 2 phases"
icon:	"across:1|width:128|height:32|border:false"
(
	undo "Copy cycle" on
		(KeyFrameManager_v( getCycleRange() )).copyKeys objs:( selection as Array )
)

/**  
 */
macroscript	template_move_c_by_AB
category:	"content-Template"
buttontext:	"MOVE C by A B"
toolTip:	"Move object on active axis about distance of two another objects.\n\nTARGET OBJECT IS 3rd IN SELECTION"
icon:	"across:1|width:128|height:32|border:false"
(
	on execute do
	(
		undo "Move obj C by A B " on
			moveObjCbyAB direction:-1
	)
)

/**  
 */
macroscript	template_repeat_phase
category:	"content-Template"
buttontext:	"R E P E A T transform"
toolTip:	""
icon:	"across:1|width:128|height:32|border:false"
(
	
	--/** Get interval
	-- */
	--function getPhaseRange =
	--(
	--	--format "\n"; print ".getPhaseRange()"
	--	start = currentTime.frame as integer
	--	
	--	end = start + ROLLOUT_phasemaker_options.DL_phase_length.selected as integer - 1
	--	format "Interval: %\n" ([ start, end] )
	--	[ start, end ] --return
	--)
	
	--RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	PhaseCreator_v.repeatPhaseTransform( selection as Array )
	
	
)



