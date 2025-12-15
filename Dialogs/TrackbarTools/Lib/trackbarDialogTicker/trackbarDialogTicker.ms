
--win32 = win32_v()


/** Trackbar tools dialog updater
 */
struct TrackbarDialogTicker_v
(
	/* construct */
	_rollout,
	
	/* required */
	/* properties */
	/* dependency */
	/* reference */
	/* inhered */
	
	/* properties */
	buttons,
	
	/* private */
	green_color = COLOR_NAMES[#GREEN_DARK], -- coor active frame button 
	
	anim_button_state,
	
	buttons_hwnd,
	buttons_size_pos,
	buttons_docked,
		
	slider_hwnd,
	slider_pos_size,
	slider_docked,
	
	maxwin_pos_size,
		
	/* private */
	current_time,
	
	dock_state,
	
	last_pos,
	
	viewport_width,
	slider_width,
	
	pos_is_changing = false,
	
	/* STATIC */ 
	viewport_bottom_padding = 56,
	
	init = false,
	
	animation_range,
	
	/** On timer tick update Dialog
	 */
	function updateDialog =
	(
		--format "\n\n"; print "TrackbarDialogTicker_v.updateDialog()"
		/* GET BUTTON CONTROLS ON INIT */
		this._setFrameButtons()
		
		visible_buttons = this.getVisibleButtons()
		
		--current_time_changed = this._currentTimeChanged() 
		
		anim_range_changed = this._animRangeChanged()
		
		/* IF MAX WIDOW SIZE CHANGED */ 
		update_button_position = anim_range_changed or this._maxWidowSizeChanged()
		--format "update_button_position: %\n" update_button_position
		
		update_button_text = anim_range_changed or this._currentTimeChanged() 

		this._getPositionsAndSizeOfWindows()
		
		/* SET WIDTH OF SLIDER */ 
		this.setSliderWidth()
		
		
		/*------------------------------------------------------------------------------
			IF POSITION OF TIME SLIDER
		--------------------------------------------------------------------------------*/
		if this._isWindowPositionChanged() then
		(
			update_button_position = true
			
			/*------------------------------------------------------------------------------
				DOCK BUTTONS IF TIMNE SLIDER IS DOCKED
			--------------------------------------------------------------------------------*/
			if slider_docked and not buttons_docked then
				this._dockButtonsWin()
			
			/*------------------------------------------------------------------------------
				IF SLIDER UN-DOCKED
			--------------------------------------------------------------------------------*/
			else if not slider_docked and not this._windowsAreAligned() then
				this._resizeAndRepositionWindows()
					
		)

		
		/* UPDATE BUTTONS */
		if update_button_position then
			this.updateButtonsSizeAndPosition()
		
		
		if update_button_text then
			this.updateActiveButton()

		
		/* SHOW \ HIDE KEYS by type */ 
		this._filterTrackbarKeysByCurrentTool()
		
		
		/* UPDATE ANIM RANGE START \ END */ 
		_rollout.SPN_range_start.value	= animationRange.start
		_rollout.SPN_range_end.value	= animationRange.end
		

		--/* SYNC WITH GLOBAL VAROABLE */
		----if PHASE_LENGTH != _rollout.DL_phase.selected as integer then
		----	_rollout.DL_phase.selection = PHASE_LENGTH
		----
		--
		--/* IF STATE OF ANIMATION MODE IS CHANGED */ 
		if anim_button_state != animButtonState then
		(
			anim_button_state = animButtonState
			
		)
	),
	
	/** Current time changed
	 */
	function _currentTimeChanged = this.testAndResetProperty #current_time currentTime.frame,
	
	/** Max widow size changed
	 */
	function _maxWidowSizeChanged this.testAndResetProperty #maxwin_pos_size_current (this._getMaxWindowSize()),
	
	/** Is anim range changed
	 */
	function _animRangeChanged = this.testAndResetProperty #animation_range animationRange,
	
	
	/*  testAndResetProperty

	   Tests whether a property on a given object differs from a tested value.
	   If different, resets the property to the tested value and returns true.
	*/
	function testAndResetProperty key val =
	(
		--local current_value = undefined
	
		if isProperty this key then
		(
			is_changed = getProperty this key != val
			
			if is_changed then
				setProperty this key val
				
			is_changed --return
		)
		else
			false
	),

	/** Get positions and size of windows
	 */
	function _getPositionsAndSizeOfWindows =
	(
		--format "\n"; print "TrackbarDialogTicker_v._getPositionsAndSizeOfWindows()"
		
		buttons_hwnd	= this.getChildWindow "Time Slider Tools"
		
		slider_hwnd	= this.getChildWindow "Time Slider"
		
		
		/* IF BUTTONS ARE UN DOCKED */ 
		if not ( buttons_docked  = buttons_hwnd == undefined ) then 
			buttons_size_pos = windows.getWindowPos buttons_hwnd


		/* IF TIMESLIDER IS UN DOCKED */ 
		if not ( slider_docked  = slider_hwnd == undefined ) then 
			slider_pos_size = windows.getWindowPos slider_hwnd
		
		
		/* IF TIMESLIDER IS DOCKED */ 
		else if slider_hwnd == undefined then
			slider_docked_hwnd = (for control in ( windows.getChildrenHWND #max ) where control[5] == "TimeSlider" collect control[1])[1]
		
		--format "\n"
		--format "buttons_hwnd: %\n" buttons_hwnd
		--format "slider_hwnd:  %\n" slider_hwnd
		--format "slider_docked_hwnd: %\n" slider_docked_hwnd
		--format "slider_pos_size: %\n" slider_pos_size
		
		/* FORCE TO SHOW TRACKBAR IS IT IS HIDDEN */ 
		if not trackbar.visible then
		(
			showTimeSlider()
			
			this._getPositionsAndSizeOfWindows()
		)
	),
	
	/** Is window position changed
	 */
	function _isWindowPositionChanged =
	(
		--format "\n"; print "TrackbarDialogTicker_v._isWindowPositionChanged()"
		--format "last_pos: %\n" last_pos
		buttons_win_need_update = false
		
		/* INIT */ 	
		if last_pos == undefined then
		(
			last_pos = copy slider_pos_size
			
			buttons_win_need_update = true 
		)
		/* TEST CHANGE OF POSITION */ 
		else
		(
			/* TEST CHANGE OF DOCKED STATE  */ 
			dock_state_changed = slider_docked != buttons_docked
			
			
			/* IF DOCK STATE CHANGED */ 
			buttons_win_need_update = dock_state_changed
			
			
			/* IF SLIDER IS UNDOCKED */ 
			if not slider_docked and not dock_state_changed then
			(
				
				/* IF CHANGING POSITION ENDS */ 
				if pos_is_changing and last_pos == slider_pos_size then
				(
					pos_is_changing = false
				
					buttons_win_need_update = true
				)
				/* IF CHANGING POSITION STARTS */ 
				else if not pos_is_changing and last_pos != slider_pos_size then
					pos_is_changing = true
			)
			
			
			/* STORE VALUE FOR NEXT TICK */ 
			last_pos = copy slider_pos_size
		)
				
			
		buttons_win_need_update --return
	),
	
	/** Dock buttons win
	 */
	function _dockButtonsWin =
	(
		--format "\n"; print "TrackbarDialogTicker_v._dockButtonsWin()"
		
		/* SET POSITION OF BUTTONS WINDOW */ 
		windows.setWindowPos buttons_hwnd buttons_size_pos true
		
		cui.RegisterDialogBar _rollout style:#(#cui_dock_bottom)
		
		cui.DockDialogBar _rollout #cui_dock_bottom
		
		update_button_position = true
	),

	/** Resize and reposition windows
	 */
	function _resizeAndRepositionWindows =
	(
		--format "\n"; print "TrackbarDialogTicker_v._resizeAndRepositionWindows()"
		--format "slider_pos_size: %\n" slider_pos_size
		
		/* SET WINDOW WIDTH */
		if buttons_size_pos == undefined then
		(
			buttons_size_pos = copy slider_pos_size
			
			buttons_size_pos.h = 36
		)
			--format "slider_pos_size:  %\n" slider_pos_size
			--format "buttons_size_pos: %\n" buttons_size_pos
			
		buttons_size_pos.w = slider_width

		
		this.snapSliderPosition()
		
		/* ALIG POSITION */ 
		this.alignTimeSliders()
		
		/* UN DOCK BUTTONS */ 
		if buttons_docked then
		(
			cui.UnRegisterDialogBar _rollout

			buttons_hwnd = this.getChildWindow "Time Slider Tools"
		)

		/* SET POSITION OF BUTTONS WINDOW */ 
		windows.setWindowPos buttons_hwnd buttons_size_pos true

		/* SET TIME SLIDER POSITION */ 
		windows.setWindowPos slider_hwnd slider_pos_size true		
		
	),
	
	/** Windows aligned
	 */
	function _windowsAreAligned =
	(
		--format "\n"; print "TrackbarDialogTicker_v._windowsAligned()"
		--format "slider_pos_size.w: %\n" slider_pos_size.w
		--format "buttons_size_pos.w: %\n" buttons_size_pos.w
		
		if buttons_size_pos != undefined then
		(
			slider_pos_size.left == buttons_size_pos.left \  -- NOT ALIGN ALIGN LEFT
			and slider_pos_size.w == buttons_size_pos.w    \  -- WIDTH CHANGED
			and slider_pos_size.bottom == buttons_size_pos.top -- NOT ALIGN ALIGN TOP
		)
		else
			false --return
		
	),


	/** Playback
	 */
	function playback is_playing_now =
	(
		--format "\n"; print "TrackbarToolsCallback_v.playback()"

		if is_playing_now then
			sliderTime = if sliderTime >= animationRange.end.frame then
							animationRange.start.frame
						else
							sliderTime + 1
	),
	
	/** Set slider width
	 */
	function setSliderWidth =
	(
		--format "\n"; print "TrackbarDialogTicker_v.setSliderWidth()"
		--format "slider_hwnd:  %\n" slider_hwnd
		--format "buttons_hwnd: %\n" buttons_hwnd
		
		slider_width = case of
		(
			(slider_hwnd	!= undefined): slider_pos_size.w
			--(buttons_hwnd	!= undefined): buttons_size_pos.w
			default: maxwin_pos_size.w
		)
		
		--/* SET WINDOW WIDTH */
		--if buttons_size_pos != undefined then 
		--	buttons_size_pos.w = slider_width
	),
	
	
	/** Snamp time slider to 3DS MAX WINDOW
	 */
	function snapSliderPosition =
	(
		--format "\n"; print "TrackbarDialogTicker_v.snapSliderPosition()"
		snap_treshold = 128
		
		/*------------------------------------------------------------------------------
			SNAP TO LEFT EDGE
		--------------------------------------------------------------------------------*/
		if abs( slider_pos_size.x - maxwin_pos_size.left	) < snap_treshold then
		(
			/* RESET POSITION */ 
			translate slider_pos_size [ -slider_pos_size.x, 0 ]
			
			/* MOVE TO LEFT */ 
			translate slider_pos_size [ maxwin_pos_size.left + 8, 0 ]
		)
		
		/*------------------------------------------------------------------------------
			SNAP TO CENTER
		--------------------------------------------------------------------------------*/
		else if abs( slider_pos_size.center.x - maxwin_pos_size.center.x	) < maxwin_pos_size.w / 4 then
		(
			/* RESET POSITION */ 
			translate slider_pos_size [ -slider_pos_size.x, 0 ]
			
			/* MOVE WINDOW TO CENTERED POSTION */ 
			--translate slider_pos_size [ -slider_pos_size.x, 0 ]
			translate slider_pos_size [ maxwin_pos_size.center.x - ( slider_width / 2 ), 0]
		)
		
		/*------------------------------------------------------------------------------
			SNAP TO BOTTOM EDGE
		--------------------------------------------------------------------------------*/
		if abs( slider_pos_size.bottom - maxwin_pos_size.bottom	) < snap_treshold then
		(
			/* RESET POSITION */ 
			translate slider_pos_size [ 0, -slider_pos_size.y ]
			
			/* MOVE TO BOTTOM */ 
			translate slider_pos_size [ 0, maxwin_pos_size.bottom - viewport_bottom_padding - slider_pos_size.h - buttons_size_pos.h ]
		)
		
	),
	
	/** Align time sliders
	 */
	function alignTimeSliders =
	(
		--format "\n"; print "TrackbarToolsCallback_v.alignTimeSliders()"

		if slider_hwnd != undefined then
		(
			/* RESET POSITION */ 
			translate buttons_size_pos [ -buttons_size_pos.x, -buttons_size_pos.y ]
			
			translate buttons_size_pos [ slider_pos_size.x, slider_pos_size.bottom ]
		)
		else
			translate buttons_size_pos [ 0, -viewport_bottom_padding ]
	),
	
	/** Get child window
	 */
	function getChildWindow title =
	(
		--format "\n"; print "TrackbarToolsCallback_v.getChildWindow()"
		if ( window_data = windows.getChildHWND 0 title parent:#max ) != undefined then window_data[1] --return
	),
	
	/** Update buttons
	 */
	function updateButtonsSizeAndPosition =
	(
		--format "\n"; print "TrackbarDialogTicker_v.updateButtonsSizeAndPosition()"
		
		/* GET BUTTONS */ 
		frames_count = this.getFramesCount()

		--visible_buttons = for btn in buttons where btn.visible collect btn 

		/* UPDATE BUTTONS */ 
		--if update_button_position or visible_buttons.count != frames_count then
		(
			pos_x = 54 -- left margin on trackbar
			
			buttons_area = slider_width - 108

			/* FIX WIDTH OF DOCKED DIALOG */ 
			if slider_hwnd == undefined then
				buttons_area -= 20
			
			btn_width = ( buttons_area / (frames_count ) ) 
			
			
			for i = 1 to buttons.count do
			(
				/* EDIT BUTTON */ 
				buttons[i].visible = i <= frames_count
				buttons[i].width   = btn_width
				buttons[i].pos.x   = pos_x
				
				/* UPDADTE POS FOR NEXT BUTTON */ 
				pos_x += btn_width
			)
			
			/* SET POSITION OF "PLAY" BUTTON */
			pos_after_last_button = buttons[frames_count + 1].pos

		)
		
		/* WRA TEXT OF BUTTONS IN PHASE TO "[ ]" */ 
		--for key in sort buttons.keys do
			--buttons[key].text = if key > phase_start and key <= frame then  "[ "+ key as string +" ]" else key as string
	),
	
	/** Update button text and state
	 */
	function updateActiveButton =
	(
		--format "\n"; print "TrackbarDialogTicker_v.updateActiveButton()"
		this._setFrameButtons()
		
		frames_count = this.getFramesCount()

		/*------------------------------------------------------------------------------
			EDIT EACH BUTTON IN ANIM RANGE
		--------------------------------------------------------------------------------*/
		for i = 1 to frames_count where ( btn = buttons[i]) != undefined do
		(
			frame = ( animationRange.start.frame + i - 1 ) as integer
			
			/* SET BUTTON TEXT BY FRAME */ 
			btn.text = frame as string
			
			/* ADD BRACKET TO FRAMES IN PHASE */ 
			 if i > currentTime.frame - PHASE_LENGTH  and i <= currentTime.frame then
				btn.text = "[ "+ btn.text +" ]"
			
				
		
				/* TURN ALL FRAME BUTTONS OFF */ 				
				btn.state = frame == currentTime.frame
				
				if btn.state then
				(
					/* SET COLOR */ 
					btn.highlightColor = this.getFrameButtonColor frame
					
					/* SET STATE TRUE -- force to update highlight color */ 
					btn.state = true
				)
		)
	),
	
	/** Get frame buttons
	  
	  @return Dictionary #INTEGER
	 */
	function _setFrameButtons =
	(
		--format "\n"; print "._setFrameButtons()"
		if this.buttons == undefined then
			this.buttons = for ctrl in _rollout.controls where matchPattern (ctrl as string ) pattern:("*btn_frame_*") collect ctrl --return
	),
	
	/** Get frames count
	 */
	function getFramesCount =
	(
		--format "\n"; print "TrackbarDialogTicker_v.getFramesCount()"
		animationRange.end.frame - animationRange.start.frame + 1 --return
	),
	
	/** Get visible buttons
	 */
	function getVisibleButtons =
	(
		--format "\n"; print "TrackbarDialogTicker_v.getVisibleButtons()"
		for btn in buttons where btn.visible collect btn
	),
		
	/** Get frame button color
	 */
	function getFrameButtonColor frame =
	(
		--format "\n"; print "TrackbarDialogTicker_v.getFrameButtonColor()"
		--format "animButtonState: %\n" animButtonState
		if animButtonState then color 125 13 13 else ( if frame as integer != 0 then green_color else orange )
	),
	
	/** Filter trackbar keys by current tool
		
		AUTO FILTER KEYS ON TIME SLIDER: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-5120D063-E771-4700-98FF-60E4E578BE52
	 */
	function _filterTrackbarKeysByCurrentTool =
	(
		--format "\n"; print "TrackbarDialogTicker_v._filterTrackbarKeysByCurrentTool()"
		trackbar.filter = if toolmode.commandmode == #ROTATE or toolmode.commandmode == #MOVE then
			----#currentTM
			#TMOnly 
		else
			#all		
	),
	
	
	/** Get height of maximized viewport to find out height of docked dialog
	 */
	function _getViewportWidth =
	(
		--print "Dialog_v._getViewportHeight()"
		is_maximized	= viewport.numViews == 1

		--height_of_ui	= 0 -- Add heigh
		--dialog_title_height	= 30

		--if( trackbar.visible ) then
		--	height_of_ui	+= 27
		--
		--if( timeSlider.isVisible() ) then
		--	height_of_ui	+= 18

		if not( is_maximized ) then
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle

		_viewport_width = getViewSize()
		--format "viewport_area_size	= % \n" viewport_area_size
		if not( is_maximized ) then
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
			
		_viewport_width --return
	),

	
	/** Set max window size
	 */
	function _getMaxWindowSize =
	(
		--format "\n"; print "TrackbarDialogTicker_v._getMaxWindowSize()"
		windows.getWindowPos ( windows.getMAXHWND() )
	),
	
	on create do
	(
		--format "\n"; print "TrackbarDialogTicker_v.onCreate()"
		--buttons_hwnd = this.getChildWindow "Time Slider Tools"
		--slider_hwnd = this.getChildWindow "Time Slider"
		
		this.viewport_width = this._getViewportWidth()
		
		this.maxwin_pos_size = this._getMaxWindowSize()
	)
)