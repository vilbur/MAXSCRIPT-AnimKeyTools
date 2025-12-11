/* 
	Struct: TrackbarToolsCallback_v
	
	Functions for working with Time Slider and animation ranges
*/
struct TrackbarToolsCallback_v
(
	/* constuct */ 
	_rollout,
	
	/* properties */
	--buttons = Dictionary #INTEGER,
	buttons,
	/* private */
	green_color = COLOR_NAMES[#GREEN_DARK], -- coor active frame button 
	
	anim_button_state,
	
	hwnd_slider_tools,
		
	hwnd_slider_default,
	
	playback_fps = #( 24, 12, 6, 4, 2, 1 ),
	--playback_fps = #( "24", "12", "6", "4", "2", "1" ),
	
	/** Show fps rc menu
	 */
	function showFpsRcMenu =
	(
		--format "\n"; print "TrackbarToolsCallback_v.showFpsRcMenu()"
		fps_current = DIALOG_time_slider_tools.SPN_FPS_holder.value
		
		Menu = RcMenu_v name:"FpsRcMenu"
		
		/* ADD ITEMS */ 
		for fps in playback_fps do
		(
			command = "DIALOG_time_slider_tools.SPN_FPS_holder.value = " + ( fps as string )
			--format "%: %\n" fps (fps == fps_current)
			Menu.item	( fps as string ) command enabled:( fps != fps_current ) checked:( fps == fps_current )
		)
			
		Menu.popUp()
	),
	
	/** Get child window
	 */
	function getChildWindow title =
	(
		--format "\n"; print "TrackbarToolsCallback_v.getChildWindow()"
		if ( window_data = windows.getChildHWND 0 title parent:#max ) != undefined then window_data[1] --return
	),
	
	/* set frame */ 
	function setFrame frame =
	(
		--format "\n"; print "TrackbarToolsCallback_v.setFrame()"
		--format "frame: %\n" frame

		frame = frame as integer

		--if not this.isInRange(frame) then
			--return false
		
		sliderTime = frame
		
		/*------------------------------------------------------------------------------
			SYNC CONTROLS 
		--------------------------------------------------------------------------------*/


		
		/* SLIDER */ 
		--_rollout.slider_current_time.value = frame
	),
	
	/** Set interval
	 */
	function setInterval val =
	(
		--format "\n"; print "TrackbarToolsCallback_v.setInterval()"
		--format "EventFired: %\n" EventFired
		fps = EventFired.Control.selected as integer

		_rollout.clock.interval = 1000 / fps
	),
	
	--/** Set next frame
	-- */
	--function setNextFrame =
	--(
	--	--format "\n"; print "TrackbarToolsCallback_v.setNextFrame()"
	--		if sliderTime >= animationRange.end.frame then
	--		sliderTime = animationRange.start.frame 
	--	else
	--		sliderTime += 1
	--		
	--	this.setFrame sliderTime.frame
	--),
	--
	/* Is in range */
	function isInRange frame =
	(
		--format "\n"; print "TrackbarToolsCallback_v.isInRange()"
		--format "frame: %\n" frame

		frame >= animationRange.start.frame and frame <= animationRange.end.frame
	),
	
	/** Select objects with key
	 */
	function selectObjectsWithKey frame =
	(
		--format "\n"; print "TrackbarToolsCallback_v.selectObjectsWithKey()"
		
		--format "\n FUNCTION IS PLACHOLDER"
	),
	
	/* Go to frame
	 * 
	 * @param -1|1 direction 
	*/
	function jumpToPhase direction =
	(
		--format "\n"; print "TrackbarToolsCallback_v.jumpToPhase()"
		--format "EventFired: %\n" EventFired
		--direction = if EventFired.type == #rightClick  then -1 else 1
		
		frames_increment = this._getPhaseLenght()
		
		next_frame = sliderTime.frame + (frames_increment * direction )
		
		if this.isInRange(next_frame) then
			this.setFrame next_frame
	),

	
	/* Set anim range */
	function setAnimRange start: end: =
	(
		--format "\n"; print "TrackbarToolsCallback_v.setAnimRange()"
		
		--local _Interval
		_Interval = animationRange
		
		frame = (if start != unsupplied then start else end) as integer
		
		
		if not keyboard.controlPressed then
		(
			_Interval = if start != unsupplied then Interval frame (animationRange.end.frame) else Interval (animationRange.start.frame) frame
	
			--format "TEST: %\n" (_Interval.start.frame as integer == _Interval.end.frame as integer )
			/* Prevent zero length anim range */
			--format "_INTERVAL: %\n" _Interval
			
			if _Interval.start.frame as integer == _Interval.end.frame as integer then
				 _Interval.end += 1
			
		)
		--else
		--(
		--	local last_frame_button
		--	
		--	buttons = this._getFrameButtons()
		--	--format "buttons: %\n" buttons
		--	for i = buttons.keys.count - 1 to 0 by -1  do
		--	--format "buttons[i]: %\n" buttons[i].visible
		--	
		--	for i = buttons.keys.count - 1 to 0 by -1 while last_frame_button == undefined where buttons[i].visible do last_frame_button = buttons[i]
		--	--format "last_frame_button: %\n" last_frame_button
		--	frame_start = animationRange.start.frame
		--	frame_end = animationRange.end.frame
		--	
		--	 if start != unsupplied then
		--		frame_start = _rollout.btn_range_start.text as integer
		--	else
		--		frame_end = last_frame_button.text as integer
		--	
		--	
		--	_Interval = Interval frame_start frame_end
		--)
		
		--format "_INTERVAL: %\n" _Interval
		/* Set new animation range */
		animationRange = _Interval
		
		/* Show / Hide buttons */
		--this.showHideButtonsInRange sliderTime.frame
		--
		--/* Update range buttons (UI removed) */
		--this.updateAnimRangeButtons()
		----format "SHIFT_FRAME: %\n" shift_frame
		--if shift_frame != undefined and not this.isInRange(shift_frame) then 
		--	this.setFrame shift_frame
	),


	
	--/** Get frame button
	-- */
	--function _getFrameButton frame =
	--(
	--	--format "\n"; print "TrackbarToolsCallback_v._getFrameButton()"
	--	
	--	execute ( _rollout.name + ".btn_frame_" + frame as string ) --return
	--),
	--	
	--/** Get frame button color
	-- */
	--function getFrameButtonColor frame =
	--(
	--	if animButtonState then red else ( if frame != 0 then green_color else orange )
	--),
	--
	
	/*------------------------------------------------------------------------------
		GET\SET UI VALUES
	--------------------------------------------------------------------------------*/
	
	/** Get slider value
	 */
	function _sliderValue =
	(
		--format "\n"; print "TrackbarToolsCallback_v._sliderValue()"
		_rollout.slider_current_time.value
	),
	
	/** Get phse lenght
	 */
	function _getPhaseLenght =
	(
		--format "\n"; print "TrackbarToolsCallback_v._getPhaseLenght()"
		ROLLOUT_phasemaker_options.DL_phase_length.selected as integer
	),
	
	on create do
	(
		--format "\n"; print "TrackbarToolsCallback_v.onCreate()"
		hwnd_slider_tools = this.getChildWindow "Time Slider Tools"
		hwnd_slider_default = this.getChildWindow "Time Slider"
	)
)