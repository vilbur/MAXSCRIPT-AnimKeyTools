/*------------------------------------------------------------------------------
	TIMER
--------------------------------------------------------------------------------*/
/*
*/
macroscript	AnimKeyTools_timer
category:	"_AnimKeyTools"
buttonText:	"Timer"
tooltip:	"Colorpicker test"
icon:	"control:timer|interval:500|active:true|height:0"
(
	--format "EventFired	= % \n" EventFired
	--format "DIALOG_phasemaker: %\n" DIALOG_phasemaker	
	/* ADJUST BUTTON TEXT - CREATE PHASE if first frame of range is active else COPY PHASE */
	on execute do
		if DIALOG_phasemaker != undefined then
		(
			is_current_time_on_start_of_range = animationRange.start == currentTime
			
			BTN_create_phase = DIALOG_phasemaker.BTN_create_phase
			
			BTN_mirror_phase = DIALOG_phasemaker.BTN_mirror_phase
			
			BTN_mirror_phase.pos.x = 	BTN_create_phase.pos.x =  16
			
			/* VISIBILITY OF BUTTONS  */ 
			BTN_create_phase.visible = is_current_time_on_start_of_range
			
			BTN_mirror_phase.visible = not BTN_create_phase.visible
			
		)
)

--/**  
-- */
--macroscript AnimKeyTools_rig_choose
--category:	"_AnimKeyTools"
--buttontext:	"RIG"
--toolTip:	"Open AnimKeyTools"
--icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '1', '2', '3', '4', '5', '6', '7', '8', '9')|height:10"
--(
--	format "EventFired: %\n" EventFired
--	
--)


/**  
 */
macroscript AnimKeyTools_rig
category:	"_AnimKeyTools"
buttontext:	"[Rig select]"
toolTip:	""
icon:	"control:#DROPDOWN|across:1|width:128"
(
	
	format "EventFired: %\n" EventFired
)

/*------------------------------------------------------------------------------
	PHASE
--------------------------------------------------------------------------------*/


/**  
 */
macroscript AnimKeyTools_phase_length
category:	"_AnimKeyTools"
buttontext:	"[Phase Length]"
toolTip:	"Count of frames in phase"
icon:	"control:#DROPDOWN|across:2|width:64|items:#( '1', '2', '3', '4', '5', '6', '7', '8', '9')"
(
	
	format "EventFired: %\n" EventFired
)

/**  
 */
macroscript AnimKeyTools_phase_toggle
category:	"_AnimKeyTools"
buttontext:	"Phase"
toolTip:	"Enable \ Diasable Phase"
icon:	"control:#CHECKBOX|across:2"
(
	
	format "EventFired: %\n" EventFired
	
	DIALOG_phasemaker.DL_phase_length.enabled = EventFired.val

)

/*------------------------------------------------------------------------------
	INCREMENT
--------------------------------------------------------------------------------*/

/**  
 */
macroscript AnimKeyTools_increment
category:	"_AnimKeyTools"
buttontext:	"[Increment value]"
toolTip:	"Offset from current frame where new keys are kreated.\n\nOPTION 'Phase': Increment by phase length"
--icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '1', '2', '3', '4', '5', '6', '7', '8', '9')"
icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9')"
(
	format "EventFired: %\n" EventFired
	
)

/**  
 */
macroscript AnimKeyTools_increment_toggle
category:	"_AnimKeyTools"
buttontext:	"Increment"
toolTip:	"Enable \ Diasable Increment"
icon:	"control:#CHECKBOX|across:2"
(
	
	format "EventFired: %\n" EventFired
	
	DIALOG_phasemaker.DL_increment_value.enabled = EventFired.val

)

/*------------------------------------------------------------------------------
	BUTTONS 
--------------------------------------------------------------------------------*/


/** Get phase - nuber of frames before current time
	
	[phase keys][currentTime]
	
	@return Point2 [ start time, end time ]
  
 */
function getPhaseRange dir:#BACK  =
(
	--format "\n"; print ".getPhaseRange()"
	
	
	if dir == #BACK then
	(
		end = currentTime.frame as integer 
		
		start = end + DIALOG_phasemaker.DL_phase_length.selected as integer + 1
		
	)
	else
	(
		start = currentTime.frame as integer
		
		end = start + DIALOG_phasemaker.DL_phase_length.selected as integer - 1
	)

	
	
	

	[ start, end ] --return
	
	
)

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

/*------------------------------------------------------------------------------

	BUTTONS 

--------------------------------------------------------------------------------*/



/**  
 */
macroscript	template_phase_create
category:	"_AnimKeyTools"
--buttontext:	"Frame - > Phase"
buttontext:	"C R E A T E phase"
toolTip:	"Generate phase from single frame.E.G.: Generate 1st step from first frame"
icon:	"across:2|id:#BTN_create_phase|visible:false|width:128|height:32|border:false"
(

	undo "Mirror Phase" on
	(
		increment = DIALOG_phasemaker.DL_increment_value.selected as integer
		
		rig_name = DIALOG_phasemaker.DL_rig_select.selected
		
		phase = getPhaseRange dir:#FORWARD
		
		if (trimLeft(rig_name)).count > 0 then
			(RigWrapper_v(rig_name)).mirrorPhase phase increment:increment
	
		--else
			--(KeyFrameManager_v()).copyKeys time:phase transforms:true properties:false -- default increment is length ofrange + 1
	
	)
)


/**  
 */
macroscript	template_mirror_phase
category:	"_AnimKeyTools"
--buttontext:	"Frame - > Phase"
buttontext:	"M I R R O R phase"
toolTip:	"Generate phase from single frame.E.G.: Generate 1st step from first frame"
icon:	"across:2|id:#BTN_mirror_phase|visible:false|width:128|height:32|border:false|align:#CENTER"
(
	
	PhaseCreator = PhaseCreator_v()
	
	undo "Mirror Phase" on
	(
		increment = DIALOG_phasemaker.DL_increment_value.selected as integer
		
		rig_name = DIALOG_phasemaker.DL_rig_select.selected
		
		phase = getPhaseRange()
		
		if (trimLeft(rig_name)).count > 0 then
			(RigWrapper_v(rig_name)).mirrorPhase phase increment:increment

		else
			(KeyFrameManager_v()).copyKeys time:phase transforms:true properties:false -- default increment is length ofrange + 1

	)
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
	--format "getCycleRange(): %\n" (getCycleRange())
		(KeyFrameManager_v( getCycleRange() )).copyKeys objs:( selection as Array )
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
	--	end = start + DIALOG_phasemaker.DL_phase_length.selected as integer - 1
	--	format "Interval: %\n" ([ start, end] )
	--	[ start, end ] --return
	--)
	
	--RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	PhaseCreator_v.repeatPhaseTransform( selection as Array )
	
	
)


--/**  
-- */
--macroscript	template_mirror_phase
--category:	"content-Template"
--buttontext:	"Mirror phase"
--toolTip:	"MIRROR: If 1 side is selected.\n\nSWAP: If 2 side is selected.\n\nE.G.:\n\nA) Left foot selected > MIRROR to rigt foot.\n\nB) Both feet selected > SWAP left <-> right"
--icon:	"across:1|width:128|height:32|border:false"
--(
--	--RigWrapper = RigWrapper_v()
--	--PhaseCreator = PhaseCreator_v()
--	--
--	--
--	--RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
--	--
--	--undo "mirrorPhases" on
--	--
--	--RigWrapper.mirrorPhase ( Interval 1 3 )
--)
--
--/**  
-- */
--macroscript	template_make_cycle
--category:	"content-Template"
--buttontext:	"Cycle"
--toolTip:	""
--icon:	"across:1|width:128|height:32|border:false"
--(
--	--RigWrapper = RigWrapper_v()
--	--PhaseCreator = PhaseCreator_v()
--	--
--	--
--	--RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
--	--
--	--undo "mirrorPhases" on
--	--
--	--RigWrapper.mirrorPhase ( Interval 1 3 )
--)





