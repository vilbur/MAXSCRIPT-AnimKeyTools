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
			--format "DIALOG_phasemaker: %\n" DIALOG_phasemaker
			BTN_create_phase = DIALOG_phasemaker.BTN_create_phase
			
			BTN_mirror_phase = DIALOG_phasemaker.BTN_mirror_phase
			
			BTN_mirror_phase.pos.x = 	BTN_create_phase.pos.x =  16
			
			/* VISIBILITY OF BUTTONS  */ 
			BTN_create_phase.visible = is_current_time_on_start_of_range
			
			BTN_mirror_phase.visible = not BTN_create_phase.visible
			
			/* SYNC WITH GLOBAL VAROABLE */ 
			if ( selected_pahese_length = DIALOG_phasemaker.DL_phase_length.selected ) != undefined and PHASE_LENGTH != selected_pahese_length as integer then
				DIALOG_phasemaker.DL_phase_length.selection = PHASE_LENGTH
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


/**  SELECT RIG IN SCENE
 */
macroscript AnimKeyTools_rig_select
category:	"_AnimKeyTools"
buttontext:	"[Rig select]"
toolTip:	""
icon:	"control:#DROPDOWN|across:2|align:#LEFT|width:96"
(
	
	format "EventFired: %\n" EventFired
)

/**  TOOGLE WALK ANIM LAYER
 */
macroscript AnimKeyTools_rig_lock_walk_anim_layer
category:	"_AnimKeyTools"
buttontext:	"L"
toolTip:	"LOCK\UNLOCK rotation and rotation of master walk handle"
icon:	"control:#CHECKBUTTON|id:#CBTN_toggle_walk_anim_layer|images:#('/icons/walk.bmp', '/icons/walka.bmp')|across:2|align:#RIGHT|width:32|height:32|offset:[0, -8 ]"
(
	
	format "EventFired: %\n" EventFired
	rig_name = DIALOG_phasemaker.DL_rig_select.selected 
	format "rig_name: %\n" rig_name
	if rig_name != undefined then 
	if (trimLeft(rig_name)).count > 0 then
		(RigWrapper_v(rig_name)).toggleWalkAnimLayer (not EventFired.val)
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
icon:	"control:#DROPDOWN|across:2|width:64|items:#( '1', '2', '3', '4', '5', '6', '7', '8', '9')|offset:[0, 4 ]"
(
	
	format "Phase Length: %\n" "(Phase Length)"
	format "EventFired: %\n" EventFired
	
	--if EventFired == undefined then
	--(
	--	if PHASE_LENGTH == undefined then 
	--		PHASE_LENGTH = DIALOG_phasemaker.DL_phase_length.selected as integer
	--)
	--else
		--PHASE_LENGTH = DIALOG_phasemaker.DL_phase_length.selected = EventFired.val as string
		PHASE_LENGTH = EventFired.val

)

/**  
 */
macroscript AnimKeyTools_phase_toggle
category:	"_AnimKeyTools"
buttontext:	"Phase"
toolTip:	"Enable \ Diasable Phase"
icon:	"control:#CHECKBOX|across:2|offset:[0, 4 ]"
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
icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9')|offset:[0, 0 ]"
(
	format "EventFired: %\n" EventFired
	
)

/**  
 */
macroscript AnimKeyTools_increment_toggle
category:	"_AnimKeyTools"
buttontext:	"Increment"
toolTip:	"Enable \ Diasable Increment"
icon:	"control:#CHECKBOX|across:2|offset:[0, 0 ]"
(
	
	format "EventFired: %\n" EventFired
	
	DIALOG_phasemaker.DL_increment_value.enabled = EventFired.val

)

/*------------------------------------------------------------------------------
	BUTTONS 
--------------------------------------------------------------------------------*/



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
		phase_length = DIALOG_phasemaker.DL_phase_length.selected as integer
		
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
	
	increment = DIALOG_phasemaker.DL_increment_value.selected as integer
	
	rig_name = DIALOG_phasemaker.DL_rig_select.selected
	
	phase = getPhaseRange dir:( if mode == #CREATE then #FORWARD else #BACKWARD )
	format "PHASE: %\n" phase

	if (trimLeft(rig_name)).count > 0 then
		(RigWrapper_v(rig_name)).mirrorPhase phase increment:increment

	--else
		--(KeyFrameManager_v()).copyKeys time:phase transforms:true properties:false -- default increment is length ofrange + 1
	
	
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
	undo "Create Phase" on
		createOrMirroPhase #CREATE
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



