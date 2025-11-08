--filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/moveObjCbyAB.ms" )	--"./../../../Lib/moveObjCbyAB.ms"

/*------------------------------------------------------------------------------
	TICKER - TIMER
------------------------------------------------------------------------------*/
/* UPDATE UI
*/
macroscript	AnimKeyTools_timer
category:	"_AnimKeyTools"
buttonText:	"Ticker"
tooltip:	"Colorpicker test"
--icon:	"control:timer|interval:500|active:true|height:0"
icon:	"control:timer|interval:2000|active:true|height:0"
(
	--format "ROLLOUT_phasemaker_options: %\n" ROLLOUT_phasemaker_options	
	/* ADJUST BUTTON TEXT - CREATE PHASE if first frame of range is active else COPY PHASE */
	on execute do
	(
		--format "EventFired	= % \n" EventFired
		/* DEFINE SHORTCUTS */ 
		ROLLOUT_options  = ROLLOUT_phasemaker_options
		BTN_create_phase = ROLLOUT_phasemaker_controls.BTN_create_phase
		BTN_mirror_phase = ROLLOUT_phasemaker_controls.BTN_mirror_phase
		
		/* HELPERS */ 
		rig_name = ROLLOUT_options.DL_rig_select.selected 
		
		current_time = currentTime.frame as integer

		phase_length = ROLLOUT_options.DL_phase_length.selected as integer

		phase_first_frame = current_time - phase_length + 1 

		is_phase_in_range = phase_first_frame >= animationRange.start.frame
			
		/* UPDATE IF CURRENT TIME IS CHANGED */ 
		if DIALOG_phasemaker.current_time != currentTime then
		(
			DIALOG_phasemaker.current_time = currentTime
			
			/*------------------------------------------------------------------------------
				UPDATE BUTTONS
			--------------------------------------------------------------------------------*/
			
			/* CREATE PHASE */ 
			ttip_create = "\n\nGenerate phase from single frame.\n\nE.G.: Generate 1st step from first frame"
		
			
			BTN_create_phase.tooltip = "CREATE PHASE IN FRAMES: " + current_time as string +" - " + (current_time + phase_length ) as string + ttip_create
			
			
			/* MIRROR PHASE */ 
			--ttip_mirror = "\n\nGenerate phase from single frame.\n\nE.G.: Generate 1st step from first frame"
			ttip_mirror = ""
			
			frame_source = current_time as string
			frame_target = ( current_time + phase_length ) as string
			
			frames_source =  if phase_length > 1 then (current_time - phase_length +1 ) as string + " - " + frame_source	else frame_source
			frames_target =  if phase_length > 1 then (current_time + 1) as string + " - " + frame_target	else frame_target
			
			BTN_mirror_phase.tooltip = if is_phase_in_range then
											"MIRROR FRAMES OF PHASE\n\nSOURCE FRAMES: " + frames_source +"\nTARGET FRAMES: " + frames_target + ttip_mirror
										else
											"PHASE START BEFORE ANIMATION RANGE: " + phase_first_frame as string +"\n\nMOVE CURRENT TIME TO FRAME: " + (current_time + ( abs phase_first_frame )) as string
		)
		
		/* DISABLE BUTTON MIRRO PHASE BUTTON - if current time is less then phase ( phase is extending time range start ) */ 
		BTN_mirror_phase.enabled = is_phase_in_range
		
		/* UPDATE ANIM LAYER LOCK */
		
		if DIALOG_phasemaker.RigWrapper == undefined then
		--if ( RigWrapper = DIALOG_phasemaker.RigWrapper ) == undefined then 
		(
			--DIALOG_phasemaker.RigWrapper = if rig_name != "DO NOT USE RIG" then rig_name else undefined
			DIALOG_phasemaker.RigWrapper = if rig_name != "DO NOT USE RIG" then RigWrapper_v(rig_name) else undefined
		
			if DIALOG_phasemaker.RigWrapper != undefined then
				ROLLOUT_options.CBTN_toggle_walk_anim_layer.state = DIALOG_phasemaker.RigWrapper.isAnimLayerEnabled()
		)
		/*------------------------------------------------------------------------------
			SYNC WITH GLOBAL VARIABLE
		--------------------------------------------------------------------------------*/
		if ( selected_pahese_length = ROLLOUT_options.DL_phase_length.selected ) != undefined and PHASE_LENGTH != selected_pahese_length as integer then
			ROLLOUT_options.DL_phase_length.selection = PHASE_LENGTH
	)
)

/*------------------------------------------------------------------------------

	CONTROLS

--------------------------------------------------------------------------------*/

/**  SELECT RIG IN SCENE
 */
macroscript AnimKeyTools_rig_select
category:	"_AnimKeyTools"
buttontext:	"[Rig select]"
toolTip:	"Select rig in scene to work with"
icon:	"control:#DROPDOWN|across:2|align:#LEFT|width:116|offset:[ -16, 0 ]"
(
	
	--format "EventFired: %\n" EventFired
		selected_rig = EventFired.control.items[EventFired.val]
		
	--format "selected_rig: %\n" selected_rig
		DIALOG_phasemaker.RigWrapper = if selected_rig != "DO NOT USE RIG" then selected_rig else undefined
)

/**  TOOGLE WALK ANIM LAYER
 */
macroscript AnimKeyTools_rig_lock_walk_anim_layer
category:	"_AnimKeyTools"
buttontext:	"Lock MasterWalk anim layer"
toolTip:	"LOCK\UNLOCK position and rotation of master walk control"
icon:	"control:#CHECKBUTTON|id:#CBTN_toggle_walk_anim_layer|images:#('/icons/walk.bmp', '/icons/walka.bmp')|across:2|align:#RIGHT|width:32|height:32|offset:[ 8, -8 ]|ini:false"
(
	on execute do
	(
		format "EventFired: %\n" EventFired
		rig_name = ROLLOUT_phasemaker_options.DL_rig_select.selected 
		format "rig_name: %\n" rig_name
		if rig_name != undefined then 
			if (trimLeft(rig_name)).count > 0 then
				(RigWrapper_v(rig_name)).toggleWalkAnimLayer (not EventFired.val)
		
	)
)


 

/*------------------------------------------------------------------------------
	PHASE
--------------------------------------------------------------------------------*/


/**  DROPDOWN 
 */
macroscript AnimKeyTools_phase_length
category:	"_AnimKeyTools"
buttontext:	"[Phase Length]"
toolTip:	"Count of frames in phase"
icon:	"control:#DROPDOWN|across:2|width:64|items:#( '1', '2', '3', '4', '5', '6', '7', '8', '9')|offset:[0, 4 ]"
(
	
	--format "Phase Length: %\n" "(Phase Length)"
	--format "EventFired: %\n" EventFired
	
	--if EventFired == undefined then
	--(
	--	if PHASE_LENGTH == undefined then 
	--		PHASE_LENGTH = ROLLOUT_phasemaker_options.DL_phase_length.selected as integer
	--)
	--else
		--PHASE_LENGTH = ROLLOUT_phasemaker_options.DL_phase_length.selected = EventFired.val as string
	PHASE_LENGTH = EventFired.val

	/* FORCE UPDATE UI */ 
	DIALOG_phasemaker.current_time = undefined
)

/**  CHECKBOX
 */
macroscript AnimKeyTools_phase_toggle
category:	"_AnimKeyTools"
buttontext:	"Phase"
toolTip:	"PLACEHODER CONTROL - DOES NOTNG YET\n\n Enable \ Diasable Phase"
icon:	"control:#CHECKBOX|across:2|offset:[0, 4 ]"
(
	
	--format "EventFired: %\n" EventFired
	
	ROLLOUT_phasemaker_options.DL_phase_length.enabled = EventFired.val

)

/*------------------------------------------------------------------------------
	INCREMENT
--------------------------------------------------------------------------------*/

/**  DROPDOWN 
 */
macroscript AnimKeyTools_increment
category:	"_AnimKeyTools"
buttontext:	"[Increment value]"
toolTip:	"Offset from current frame where new keys are created.\n\nOPTION 'Phase': Increment by phase length"
--icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '1', '2', '3', '4', '5', '6', '7', '8', '9')"
icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9')|offset:[0, 0 ]"
(
	/* FORCE UPDATE UI */
	DIALOG_phasemaker.current_time = undefined
)

/** CHECKBOX 
 */
macroscript AnimKeyTools_increment_toggle
category:	"_AnimKeyTools"
buttontext:	"Increment"
toolTip:	"PLACEHODER CONTROL - DOES NOTNG YET\n\n Enable \ Diasable Increment"
icon:	"control:#CHECKBOX|across:2|offset:[0, 0 ]"
(
	
	format "EventFired: %\n" EventFired
	--ROLLOUT_phasemaker_options.DL_increment_value.enabled = EventFired.val
)

/** CHECKBOX 
 */
macroscript AnimKeyTools_move_hip_with_feet
category:	"_AnimKeyTools"
buttontext:	"Move body on walk"
toolTip:	"Move MasterWalk control about step length on each step of walk"
icon:	"control:#CHECKBOX|across:1|offset:[0, 0 ]"
(
	format "EventFired: %\n" EventFired
)

