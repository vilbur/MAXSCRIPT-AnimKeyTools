/* 
	Struct: TrackbarTools_v
	
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
		
	/** Update ui
	 */
	function updateUi =
	(
		--format "\n"; print "TrackbarToolsCallback_v.updateUi()"
		this.setAnimRange animationRange.start animationRange.end
		
		this.showHideButtonsInRange currentTime.frame
		
		this.setFrame currentTime.frame		
	),
	
	/** On timer tick
	 */
	function onTimerTick is_playing_now =
	(
		--format "\n\n"; print "TrackbarTools_v.onTimerTick()"
		--format "sliderTime.frame:          %\n" sliderTime.frame
		--format "slider_current_time.value: %\n" _rollout.slider_current_time.value
		--format "TEST: %\n" ( _rollout.slider_current_time.value != sliderTime.frame )
		--_rollout.status_bar.visible = true
		--format "TEST: %\n" (_rollout.slider_current_time.value != sliderTime )
		--format "_rollout.status_bar.visible: % ANIMATIONMODE: %\n" _rollout.status_bar.visible animButtonState 
		
		/* SHOW \ HIDE RED STRIP ON TOP OF ROLLOUT IF AINMATION MODE IS ACTIVE */ 
		_rollout.status_bar.visible = animButtonState

		current_frame = currentTime.frame as integer


		this.alignTimeSliders()
		
		
		/* ENABLE CURRENT FRAME BUTTON */ 
		this.updateButtons(frame)
		
		/* UPDATE CURRENT FRAME */ 
		if not is_playing_now then
		(
			--_rollout.slider_time = sliderTime.frame
		
			--if this._sliderValue() != sliderTime.frame then
			if _rollout.slider_time != sliderTime.frame then
				this.setFrame sliderTime.frame

			_rollout.slider_time = sliderTime.frame
			
		)
		--else /* SET NEXT FRAME OF PALYING ANIMATION */ 
		--	this.setNextFrame()
			
			
		/*
			AUTO FILTER KEYS ON TIME SLIDER
		  
			https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-5120D063-E771-4700-98FF-60E4E578BE52
		*/ 
		trackbar.filter = if toolmode.commandmode == #ROTATE or toolmode.commandmode == #MOVE then
			--#currentTM
			#TMOnly 
		else
			#all

			
		/* SYNC WITH GLOBAL VAROABLE */
		--if PHASE_LENGTH != _rollout.DL_phase.selected as integer then
		--	_rollout.DL_phase.selection = PHASE_LENGTH
		--
		
		/* IF STATE OF ANIMATION MODE IS CHANGED */ 
		if anim_button_state != animButtonState then
		(
			anim_button_state = animButtonState
			
			/* UPDATE HIGHLIGH COLOR OF BUTTON */ 
			if ( frame_button = this._getFrameButton current_frame ) != undefined then
			(
				frame_button.highlightColor = (this.getFrameButtonColor current_frame)
		
				frame_button.state = false
				frame_button.state = true
			)
		)

	),
	
	/** Align time sliders
	 */
	function alignTimeSliders =
	(
		--format "\n"; print "TrackbarToolsCallback_v.alignTimeSliders()"
		--hwnd_slider_tools = if ( window_data = windows.getChildHWND 0 "Time Slider Tools" parent:#max ) != undefined then window_data[1]
		--
		--hwnd_slider_default = if ( window_data = windows.getChildHWND 0 "Time Slider" parent:#max ) != undefined then window_data[1]

		
		if hwnd_slider_tools != undefined and hwnd_slider_default != undefined then 
		(
			slider_tools_pos = windows.getWindowPos hwnd_slider_tools
			--format "slider_tools_pos: %\n" slider_tools_pos
			slider_default_pos = windows.getWindowPos hwnd_slider_default
			
			if slider_default_pos.x != slider_tools_pos.x then
			--if slider_default_pos.x != slider_tools_pos.x or slider_default_pos.w != slider_tools_pos.w then
			(
				
				slider_default_height = 95
		
				slider_default_pos_new = Box2 (slider_default_pos.x) (slider_default_pos.y) (slider_tools_pos.w ) (slider_default_height)  -- return
				
				/* RESIZE SLIDER */
				windows.setWindowPos hwnd_slider_default slider_default_pos_new true
				
				slider_tools_pos = windows.getWindowPos hwnd_slider_tools
				slider_default_pos = windows.getWindowPos hwnd_slider_default
				
				slider_tools_pos_new = Box2 (slider_default_pos.x) (slider_default_pos.y + slider_default_height) (slider_tools_pos.w ) (slider_tools_pos.h)  -- return
				
				/* ALIGN POSITION SLIDER */
				windows.setWindowPos hwnd_slider_tools slider_tools_pos_new true
			)
			
		)
		
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
		--format "\n"; print "TrackbarTools_v.setFrame()"
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
		--format "\n"; print "TrackbarTools_v.setInterval()"
		--format "EventFired: %\n" EventFired
		fps = EventFired.Control.selected as integer

		_rollout.clock.interval = 1000 / fps
	),
	
	/** Set next frame
	 */
	function setNextFrame =
	(
		--format "\n"; print "TrackbarTools_v.setNextFrame()"
			if sliderTime >= animationRange.end.frame then
			sliderTime = animationRange.start.frame 
		else
			sliderTime += 1
			
		this.setFrame sliderTime.frame
	),
	
	/* Is in range */
	function isInRange frame =
	(
		--format "\n"; print "TrackbarTools_v.isInRange()"
		--format "frame: %\n" frame

		frame >= animationRange.start.frame and frame <= animationRange.end.frame
	),
	
	/** Select objects with key
	 */
	function selectObjectsWithKey frame =
	(
		format "\n"; print "TrackbarTools_v.selectObjectsWithKey()"
		
		format "\n FUNCTION IS PLACHOLDER"
	),
	

	/* Show / hide buttons in range (logic placeholder, UI removed) */
	function showHideButtonsInRange frame =
	(
		-- originally changed button visibility, now only logic kept
		
		buttons = this._getFrameButtons()
		
		for frame_of_button in sort buttons.keys where frame_of_button != frame do
			buttons[frame_of_button].visible = this.isInRange frame_of_button
	),
	
	/** Update buttons
	 */
	function updateButtons frame =
	(
		--format "\n"; print "TrackbarTools_v.updateButtons()"
		
		if buttons == undefined then 
			buttons = this._getFrameButtons()

		frames_in_range = animationRange.end.frame - animationRange.start.frame + 1
		--format "frames_in_range: %\n" frames_in_range
		visible_buttons = for btn in buttons where btn.visible collect btn 
		
		--hwnd_slider_default = this.getChildWindow "Time Slider"
		
		dialog_width = (windows.getWindowPos hwnd_slider_default).w
		buttons_area = dialog_width - 108
		
		--btn_width = (buttons_area / frames_in_range) as integer
		btn_width = (buttons_area / (frames_in_range ) ) 
		--format "dialog_size: %\n" dialog_size
		--format "visible_buttons[1].text: %\n" visible_buttons[1].text
		
		

		--pos_x = 36
		pos_x = 54
		
		if visible_buttons[1].text as integer != animationRange.start.frame as integer then
			for i = 1 to buttons.count do
				buttons[i].text = (( animationRange.start.frame + i - 1 ) as integer ) as string

		--format "visible_buttons.count: %\n" visible_buttons.count
		--format "frames_in_range: %\n" frames_in_range
		--format "TEST: %\n" (visible_buttons.count != frames_in_range)
				
		if visible_buttons.count != frames_in_range then
		(
			--format "\n"
			--format "frames_in_range: %\n" frames_in_range
			--format "dialog_width: %\n" dialog_width
			--format "buttons_area: %\n" buttons_area
			--format "btn_width: %\n" btn_width
			for i = 1 to buttons.count do
			(
				
				
				
				buttons[i].visible = i <= frames_in_range
				buttons[i].width   = btn_width
				buttons[i].pos.x   = pos_x
				
				pos_x += btn_width
				
				--format "pos_x: %\n" pos_x
				--buttons[i].text = "i as string"
				
				--if i <= frames_in_range then
					--format "pos_x: %\n" pos_x
			)
			
		)
		
		
		
		--format "buttons[frames_in_range]: %\n" buttons[frames_in_range].pos.x
		--dialog_width = buttons[frames_in_range].pos.x	+ btn_width + 18

		--setDialogSize _rollout [ dialog_width, dialog_size.y ]
		
		--phase_lenght = this._getPhaseLenght()
		
		--phase_start = frame - phase_lenght
		
		--/* DISBALE OTHER FRAME BUTTONS */ 
		--for key in sort buttons.keys do
		--(
		--	is_current_frame_button = key == frame
		--	
		--	buttons[key].state = is_current_frame_button
		--	
		--	buttons[key].highlightColor = this.getFrameButtonColor frame
		--)
		
		/* WRAP TEXT OF BUTTONS IN PHASE TO "[ ]" */ 
		--for key in sort buttons.keys do
			--buttons[key].text = if key > phase_start and key <= frame then  "[ "+ key as string +" ]" else key as string
	),
	
	/* Go to frame
	 * 
	 * @param -1|1 direction 
	*/
	function jumpToPhase direction =
	(
		--format "\n"; print "TrackbarTools_v.jumpToPhase()"
		--format "EventFired: %\n" EventFired
		--direction = if EventFired.type == #rightClick  then -1 else 1
		
		frames_increment = this._getPhaseLenght()
		
		next_frame = sliderTime.frame + (frames_increment * direction )
		
		if this.isInRange(next_frame) then
			this.setFrame next_frame
	),

	/* Update anim range buttons (UI removed) */
	function updateAnimRangeButtons =
	(
		_rollout.btn_range_start.text = ( (animationRange.start.frame as integer ) as string )

		_rollout.btn_range_end.text   = ( (  animationRange.end.frame as integer ) as string )
	),
	
	/* Set anim range */
	function setAnimRange start_or_end frame =
	(
		--format "\n"; print "TrackbarTools_v.setAnimRange()"
		
		local _Interval
			
		
		if not keyboard.controlPressed then
		(
			_Interval = if start_or_end == #START then Interval frame (animationRange.end.frame) else Interval (animationRange.start.frame) frame
	
			--format "TEST: %\n" (_Interval.start.frame as integer == _Interval.end.frame as integer )
			/* Prevent zero length anim range */
			--format "_INTERVAL: %\n" _Interval
			
			if _Interval.start.frame as integer == _Interval.end.frame as integer then
				 _Interval.end += 1
			
		)
		else
		(
			local last_frame_button
			
			buttons = this._getFrameButtons()
			--format "buttons: %\n" buttons
			for i = buttons.keys.count - 1 to 0 by -1  do
			--format "buttons[i]: %\n" buttons[i].visible
			
			for i = buttons.keys.count - 1 to 0 by -1 while last_frame_button == undefined where buttons[i].visible do last_frame_button = buttons[i]
			--format "last_frame_button: %\n" last_frame_button
			frame_start = animationRange.start.frame
			frame_end = animationRange.end.frame
			
			 if start_or_end == #END then
				frame_end = last_frame_button.text as integer
			else
				frame_start = _rollout.btn_range_start.text as integer
			
			
			_Interval = Interval frame_start frame_end
		)
		
		
		if currentTime == animationRange.start or currentTime == animationRange.end then
			shift_frame = _Interval.start.frame
		
		--format "_INTERVAL: %\n" _Interval
		/* Set new animation range */
		animationRange = _Interval
		
		/* Show / Hide buttons */
		this.showHideButtonsInRange sliderTime.frame
		
		/* Update range buttons (UI removed) */
		this.updateAnimRangeButtons()
		--format "SHIFT_FRAME: %\n" shift_frame
		if shift_frame != undefined and not this.isInRange(shift_frame) then 
			this.setFrame shift_frame
	),


	
	/** Get frame button
	 */
	function _getFrameButton frame =
	(
		--format "\n"; print "TrackbarTools_v._getFrameButton()"
		
		execute ( _rollout.name + ".btn_frame_" + frame as string ) --return
	),
		
	/** Get frame button color
	 */
	function getFrameButtonColor frame =
	(
		if animButtonState then red else ( if frame != 0 then green_color else orange )
	),
	
	
	/*------------------------------------------------------------------------------
		GET\SET UI VALUES
	--------------------------------------------------------------------------------*/
	
	/** Get slider value
	 */
	function _sliderValue =
	(
		--format "\n"; print "TrackbarTools_v._sliderValue()"
		_rollout.slider_current_time.value
	),
	
	/** Get phse lenght
	 */
	function _getPhaseLenght =
	(
		--format "\n"; print "TrackbarTools_v._getPhaseLenght()"
		_rollout.DL_phase.selected as integer
	),
	
	on create do
	(
		format "\n"; print "TrackbarTools_v.onCreate()"
		hwnd_slider_tools = this.getChildWindow "Time Slider Tools"
		hwnd_slider_default = this.getChildWindow "Time Slider"
	)
)