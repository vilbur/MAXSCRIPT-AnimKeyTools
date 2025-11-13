/**  TOGGLE TRACKBAR
 */
macroscript	_options_trackbar_show
category:	"_Animation"
buttontext:	"Trackbar Toggle"
icon:	"ACROSS:2"
(
	on execute do
	(
		state = trackbar.visible
	
		trackbar.visible = not state
	
		timeSlider.setVisible (not state)
	
		if state == trackbar.visible then
			messageBox "Toggle does not work because of 3Ds Max Bug.\n\nWORKAROUND:\n\nRight-click on an empty area of the top Toolbar to bring up the drop-down menu, and click on the Time Slider checkbox." title:"SHOW TIMESLIDDE"
		
	)
)

/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_set_frame_next
category:	"_Animation"
buttontext:	"Shift Frame"
tooltip:	"Set Next Anim Frame"
icon:	"ACROSS:2"
(
	on execute do
		shiftCurrentTime 1

)

/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_set_frame_prev
category:	"_Animation"
buttontext:	"Shift Frame"
tooltip:	"Set Previous Anim Frame"
icon:	"ACROSS:2"
(
	on execute do
		shiftCurrentTime -1

)



/*
	"./../../../CallBacks/filePostOpen/checkWorldUnits.ms"
*/ 
macroscript	_animation_set_animation_range
category:	"_Animation"
buttontext:	"AUTO SET ANIMATION RANGE"
tooltip:	"ON SCENE OPEN:\n\n  Set number of animation frames by highest key used in scene"
icon:	"ACROSS:1|control:checkbox|MENU:true"
(
	/* https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-5A4580C6-B5CF-12104-898B-9313D1AAECD4 */
	--on isEnabled return selection.count > 0

	on execute do
	(
		--format "EventFired: %\n" EventFired
		try(
			
			if EventFired == undefined or ( EventFired != undefined and EventFired.val ) then
			(
				autoSetAnimationRange()
				
				CALLBACKMANAGER.start "autoSetAnimationRange"
				
				cbx_state = true
			)
			else
			(
				CALLBACKMANAGER.kill "autoSetAnimationRange"
				
				cbx_state = false
			)
			
		/* UPDATE UI */ 
		if ROLLOUT_animation != undefined then 
			ROLLOUT_animation.CBX_auto_set_animation_range.state = cbx_state
			
		)catch()
	)
	
)

/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_range_start
category:	"_Animation"
buttontext:	"Start"
tooltip:	"Set first frame of range"
icon:	"control:spinner|type:#integer|ACROSS:2|align:#LEFT|fieldwidth:48|range:[0,1000,100]|offset:[ 0, 2 ]"
(
	on execute do
	(
		format "EventFired: %\n" EventFired	
		
		start = ROLLOUT_animation.SPIN_range.value
		end   = ROLLOUT_animation.SPIN_to.value
		
		if start >= end then
		(
			end = start + 1
			
			ROLLOUT_animation.SPIN_to.value = end
		)
		
		animationRange = Interval start end
	)
	
)
/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_range_end
category:	"_Animation"
buttontext:	"End"
tooltip:	"Set last frame of range"
icon:	"control:spinner|type:#integer|ACROSS:2|align:#LEFT|fieldwidth:48|range:[1,1000,100]|offset:[ 0, 2 ]"
(
	on execute do
	(
		format "EventFired: %\n" EventFired	
		
		start = ROLLOUT_animation.SPIN_range.value
		end   = ROLLOUT_animation.SPIN_to.value
		
		if start >= end then
		(
			start = end - 1
			
			ROLLOUT_animation.SPIN_range.value = start
		)
			
		animationRange = Interval start end
	)
	
)



