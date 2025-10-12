
filein( getFilenamePath(getSourceFileName()) + "/../AnimKeyTools.ms" )	--"./../AnimKeyTools.ms"

filein( getFilenamePath(getSourceFileName()) + "/TrackbarTools/frameButtonRcMenu/frameButtonRcMenu.ms" )	--"./TrackbarTools/frameButtonRcMenu/frameButtonRcMenu.ms"

filein( getFilenamePath(getSourceFileName()) + "/TrackbarTools/trackbarToolsDialog.ms" )	--"./TrackbarTools/trackbarToolsDialog.ms"



/* 
	Struct: TrackbarTools_v
	Functions for working with Time Slider and animation ranges
*/
struct TrackbarTools_v
(
	/* constuct */ 
	_rollout,
	
	/* properties */
	
	/* private */
	green_color = COLOR_NAMES[#DARKGREEN], -- coor active frame button 
	
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

		
		/* UPDATE CURRENT FRAME */ 
		if not is_playing_now then
		(
			if this._sliderValue() != sliderTime.frame then
				this.setFrame sliderTime.frame
			
		)
		else /* SET NEXT FRAME OF PALYING ANIMATION */ 
			this.setNextFrame()
			
			
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
		if PHASE_LENGTH != _rollout.DL_phase.selected as integer then
			_rollout.DL_phase.selection = PHASE_LENGTH 
	),
	
	/* set frame */ 
	function setFrame frame =
	(
		--format "\n"; print "TrackbarTools_v.setFrame()"
		--format "frame: %\n" frame

		frame = frame as integer
		--format "FRAME: %\n" FRAME
		if not this.isInRange(frame) then
			return false
		
		sliderTime = frame
		
		/*------------------------------------------------------------------------------
			SYNC CONTROLS 
		--------------------------------------------------------------------------------*/
		
		/* ENABLE CURRENT FRAME BUTTON */ 
		this.updateButtons(frame)

		
		/* SLIDER */ 
		_rollout.slider_current_time.value = frame
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
		
		/** Get frame button color
		 */
		function getFrameButtonColor frame =  if animButtonState then red else ( if frame > 0 then green_color else orange )
		

		phase_lenght = this._getPhaseLenght()
		
		buttons = this._getFrameButtons()
		
		
		/* DISBALE OTHER FRAME BUTTONS */ 
		for key in sort buttons.keys do
		(
			is_current_frame_button = key == frame
			
			buttons[key].state = is_current_frame_button
			
			--buttons[key].highlightColor =  getFrameButtonColor frame
		)
		
		/* WRAP TEXT OF BUTTONS IN PHASE TO "[ ]" */ 
		for key in sort buttons.keys do
			buttons[key].text = if key > frame and key < frame + phase_lenght then  "[ "+ key as string +" ]" else key as string
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

	/** Get frame buttons
	 */
	function _getFrameButtons =
	(
		--format "\n"; print "._getFrameButtons()"
		buttons	=  Dictionary #INTEGER
		--format "_rollout.controls: %\n" _rollout.controls
		--for ctrl in _rollout.controls do
		--format "ctrl: %\n" ctrl
		
		--buttons = for ctrl in _rollout.controls where matchPattern ctrl.name pattern:("btn_frame_*") collect ctrl
		only_frame_buttons = for ctrl in _rollout.controls where matchPattern (ctrl as string ) pattern:("*btn_frame_*") collect ctrl
		
		for i = 0 to only_frame_buttons.count - 1 collect buttons[i] = only_frame_buttons[i +1]
		
		buttons --return
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
		--format "\n"; print "TrackbarTools_v.onCreate()"
		this.setAnimRange animationRange.start animationRange.end
		
		this.showHideButtonsInRange currentTime.frame
		
		this.setFrame currentTime.frame
	)
)


/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/
trackbarToolsDialog()