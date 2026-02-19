/** UPDATE TRACKBAR DIALOG ON EACH TIMER TICK
 */
struct TrackbarDialogTicker_v
(
	/* construct */
	_rollout, --"./../../trackbarToolsDialog.ms"
	
	/* required */
	/* properties */
	/* dependency */
	/* reference */
	/* inhered */
	
	/* properties */
	buttons,
	
	/* private */
	green_color = COLOR_NAMES[#GREEN_DARK], -- coor active frame button 
	
	
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
	
	slider_pos_size_last,
	
	viewport_width,
	slider_width,
	
	pos_is_changing_now = false,
	
	max_win_hwnd,
	
	/* STATIC */ 
	viewport_bottom_padding = 60,
	
	init = false,
	
	animation_range,
	anim_button_state,
	
	/** On timer tick update Dialog
	 */
	function updateDialog =
	(
		--format "\n\n"; print "TrackbarDialogTicker_v.updateDialog()"
		
		anim_range_changed = this._animRangeChanged()
		
		max_win_pos_changed = this._maxWidowSizeChanged()
		--format "max_win_pos_changed: %\n" max_win_pos_changed
		/* IF MAX WIDOW SIZE CHANGED */ 
		update_button_position = anim_range_changed or max_win_pos_changed
		--format "update_button_position: %\n" update_button_position
		/* GET BUTTON CONTROLS ON INIT */
		this._setFrameButtons()
		
		this._getPositionsAndSizeOfWindows()
		

		/* SET WIDTH OF SLIDER */ 
		this.setThisSliderWidth()
		
		/*==============================================================================
			POSITION OF TIME SLIDER
		================================================================================*/
		if this._isPosSizeOfNativeSliderChanged() then
		(
			update_button_position = true
			
			
			/*------------------------------------------------------------------------------
				DOCK BUTTONS IF TIME SLIDER IS DOCKED
			--------------------------------------------------------------------------------*/
			if slider_docked and not buttons_docked then
				this._dockButtonsWin()
			
			
			/*------------------------------------------------------------------------------
				ALIGN WINDOWS IF SLIDER UN-DOCKED
			--------------------------------------------------------------------------------*/
			else if not slider_docked and not this._windowsAreAligned() then
				this._resizeAndRepositionWindows()
					
		)
		else if max_win_pos_changed then
			this._resizeAndRepositionWindows()

		--format "update_button_position: %\n" update_button_position

		
		
		/* UPDATE BUTTONS SIZE AND POSITION */
		if update_button_position then
			this.updateButtonsSizePosition()
		
		
		
		/* UPDATE ACTIVE FRAME BUTTON */
		if anim_range_changed then
			this.updateActiveButton force:true
		
		
		
		/* SHOW \ HIDE KEYS by type: trnasforms|properties */ 
		this._filterTrackbarKeysByCurrentTool()
		
		
		
		/* UPDATE ANIM RANGE START \ END */ 
		_rollout.SPN_range_start.value	= animationRange.start
		_rollout.SPN_range_end.value	= animationRange.end
		
		
		--/* SYNC WITH GLOBAL VAROABLE */
		----if PHASE_LENGTH != _rollout.DL_phase.selected as integer then
		----	_rollout.DL_phase.selection = PHASE_LENGTH
		----
		--/* IF STATE OF ANIMATION MODE IS CHANGED */ 
		if this._animStateChanged() then
			this.udpateHighlightColor()
		
		animation_range = animationRange
	),
	
	/** Update button text and state
	 */
	function updateActiveButton force:false =
	(

		/*------------------------------------------------------------------------------
			EDIT EACH BUTTON IN ANIM RANGE
		--------------------------------------------------------------------------------*/
		
		if force == true or this._currentTimeChanged() then
		(
			--format "\n"; print "TrackbarDialogTicker_v.updateActiveButton()"

			this._setFrameButtons()
			
			frames_count = this.getFramesCount()
			--format "currentTime.frame: %\n" currentTime.frame
			--format "\n"; print "TrackbarDialogTicker_v.updateActiveButton()"
			for i = 1 to frames_count where ( btn = buttons[i]) != undefined do
			(
				frame = ( animationRange.start.frame + i - 1 ) as integer
				--format "frame: %\n" frame
				--current_time_frame = currentTime.frame as integer + 1
				
				/* SET BUTTON TEXT BY FRAME */ 
				btn.text = frame as string
				
				/* WRAP TEXT OF BUTTONS IN PHASE TO "[ ]" */ 
				 if frame > currentTime.frame - PHASE_LENGTH  and frame <= currentTime.frame then
					btn.text = "[ "+ btn.text +" ]"
					
			
					/* TURN ALL FRAME BUTTONS OFF */ 				
					btn.state = frame == currentTime.frame
					
					if btn.state then
					(
						/* SET COLOR */ 
						btn.highlightColor = this.getFrameButtonColor frame
						
						/* FORCE TO UPDATE HIGHLIGHT COLOR */ 
						btn.state = true
					)
			)
		)
	),
	
	/** Udpate highlight color
	 */
	function udpateHighlightColor =
	(
		--format "\n"; print "TrackbarDialogTicker_v.udpateHighlightColor()"
		frames_count = this.getFramesCount()
		
		for i = 1 to frames_count where ( btn = buttons[i]) != undefined do
		(
			frame = ( animationRange.start.frame + i - 1 ) as integer
			
			btn.highlightColor = this.getFrameButtonColor frame

			/* FORCE TO UPDATE HIGHLIGHT COLOR */ 
			if btn.state then
			(
				btn.state = not btn.state
					
				btn.state = not btn.state
			)
		)
	),
	
	/** Current time changed
	 */
	function _currentTimeChanged = this.testAndResetProperty #current_time currentTime.frame,
	
	/** Max widow size changed
	 */
	function _maxWidowSizeChanged = this.testAndResetProperty #maxwin_pos_size (this._getMaxWindowSize()),
	
	/** Anim state changed
	 */
	function _animStateChanged =  this.testAndResetProperty #anim_button_state animButtonState,

	/** Is anim range changed
	 */
	function _animRangeChanged = animation_range != undefined and ( animation_range.start != animationRange.start or animation_range.end != animationRange.end ),
	

	--function _animRangeChanged =
	--(
	--	wtf = this.testAndResetProperty #animation_range animationRange
	----format "wtf: %\n" wtf
	--wtf --return
	--)
	--
	--,
	--
	--
	/*  ests whether a property on a given object differs from a tested value.
	    
	   If different, resets the property to the tested value and returns true.
	   
	   @return boolean 
	*/
	function testAndResetProperty key val_new =
	(
		--format "\n\n"; print "TrackbarDialogTicker_v.testAndResetProperty()"

		/* IF PROP EXISTS */ 			
		if isProperty this key then
		(
			is_changed = getProperty this key != val_new
			
			--format "is_changed: %\n" is_changed
			if is_changed then
				setProperty this key val_new
				
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
	function _isPosSizeOfNativeSliderChanged =
	(
		--format "\n\n"; print "TrackbarDialogTicker_v._isPosSizeOfNativeSliderChanged()"
		--format "slider_pos_size_last: %\n" slider_pos_size_last
		--format "slider_pos_size_last: %\n" slider_pos_size_last
		
		/*------------------------------------------------------------------------------
			ON INIT
		--------------------------------------------------------------------------------*/
		if slider_pos_size_last == undefined then
		(
			slider_pos_size_last = copy slider_pos_size
			
			true --return
		)
		/*------------------------------------------------------------------------------
			TEST CHANGE OF POSITION -- wait then user end with resizing or move ends
		--------------------------------------------------------------------------------*/
		else
		(
			/* TEST CHANGE OF DOCKED STATE  */ 
			dock_state_changed = slider_docked != buttons_docked
			--format "dock_state_changed: %\n" dock_state_changed
			
			/* IF DOCK STATE CHANGED */ 
			pos_size_of_native_slider_changed = dock_state_changed
			
			
			/* IF SLIDER IS UNDOCKED */ 
			if not slider_docked and not dock_state_changed then
			(
				
				/* IF CHANGING POSITION ENDS */ 
				if pos_is_changing_now and slider_pos_size_last == slider_pos_size then
				(
					pos_is_changing_now = false
				
					pos_size_of_native_slider_changed = true
				)
				/* IF CHANGING POSITION STARTS */ 
				else if not pos_is_changing_now and slider_pos_size_last != slider_pos_size then
					pos_is_changing_now = true
			)
			
			
			/* STORE VALUE FOR NEXT TICK */ 
			slider_pos_size_last = copy slider_pos_size
			
			pos_size_of_native_slider_changed --return
		)
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
		
		--/* SET WINDOW WIDTH */
		--if buttons_size_pos == undefined then
		--(
		--	format "\nWTF"
		--	
		--	buttons_size_pos = copy slider_pos_size
		--	
		--	--buttons_size_pos.h = 36
		--)
		--format "slider_pos_size:  %\n" slider_pos_size
		--format "buttons_size_pos: %\n" buttons_size_pos
			
		buttons_size_pos.w = slider_width

		

		
		/* UN DOCK BUTTONS */ 
		if buttons_docked then
		(
			cui.UnRegisterDialogBar _rollout

			buttons_hwnd = this.getChildWindow "Time Slider Tools"
		)
		else
		(
			/* SNAP TO LEFT | CENTER | BOTTOM */ 
			this.snapSliderPosition()
			
			/* ALIG POSITION WINDOWS TOP \ BOTTOM */ 
			this.alignTimeSliders()
			
		)

		--format "buttons_size_pos: %\n" buttons_size_pos
		
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
	function setThisSliderWidth =
	(
		--format "\n"; print "TrackbarDialogTicker_v.setThisSliderWidth()"
		--format "slider_hwnd:  %\n" slider_hwnd
		--format "buttons_hwnd: %\n" buttons_hwnd
		
		this.slider_width = case of
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
			SNAP TO CENTER
		--------------------------------------------------------------------------------*/
		/* IF DISABLED DISABLED - IT MAKES SLIDER PINNED TO CENTER */ 
		----if abs( slider_pos_size.center.x - maxwin_pos_size.center.x	) < maxwin_pos_size.w / 4 then
		(
			/* RESET POSITION */ 
			translate slider_pos_size [ -slider_pos_size.x, 0 ]
			
			/* MOVE WINDOW TO CENTERED POSTION */ 
			--translate slider_pos_size [ -slider_pos_size.x, 0 ]
			translate slider_pos_size [ maxwin_pos_size.center.x - ( slider_width / 2 ), 0]
		)
		
		
		/*------------------------------------------------------------------------------
			SNAP TO LEFT EDGE
		------------------------------------------------------------------------------*/
		----else if abs( slider_pos_size.x - maxwin_pos_size.left	) < snap_treshold then
		----(
		----	/* RESET POSITION */ 
		----	translate slider_pos_size [ -slider_pos_size.x, 0 ]
		----	
		----	/* MOVE TO LEFT */ 
		----	translate slider_pos_size [ maxwin_pos_size.left + 8, 0 ]
		----)
		
		
		/*------------------------------------------------------------------------------
			SNAP TO BOTTOM EDGE
		--------------------------------------------------------------------------------*/
		/* IF DISABLED DISABLED - IT MAKES SLIDER PINNED TO BOTTOM */ 
		----if abs( slider_pos_size.bottom - maxwin_pos_size.bottom	) < snap_treshold then
		(
			/* RESET POSITION */ 
			translate slider_pos_size [ 0, -slider_pos_size.y ]
			
			/* MOVE TO BOTTOM */ 
			translate slider_pos_size [ 0, maxwin_pos_size.bottom - viewport_bottom_padding - slider_pos_size.h - buttons_size_pos.h - 4 ]
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
	function updateButtonsSizePosition =
	(
		--format "\n"; print "TrackbarDialogTicker_v.updateButtonsSizePosition()"
		
		/* GET BUTTONS */ 
		frames_count = this.getFramesCount()

		
		
		
		--visible_buttons = for btn in buttons where btn.visible collect btn 

		/* UPDATE BUTTONS */ 
		----if update_button_position or visible_buttons.count != frames_count then
		--(
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
			
			/* UPDATE POSITION OF "PLAY" BUTTON */
			last_button = if buttons[frames_count + 1] == undefined then frames_count else frames_count + 1
			
			pos_after_last_button = buttons[last_button].pos

		--)
		
		
		/* SET POSITION OF "PLAY" BUTTON */
		_rollout.BTN_play.pos = pos_after_last_button

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
		if animButtonState then color 125 13 13 else ( if frame as integer != 0 then green_color else color 220 120 20 )
	),
	
	/** Filter trackbar keys by current tool
		
		AUTO FILTER KEYS ON TIME SLIDER: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-5120D063-E771-4700-98FF-60E4E578BE52
	 */
	function _filterTrackbarKeysByCurrentTool =
	(
		transform_tools = #(
			#USCALE,
			#NUSCALE,
			#SQUASH,
			#ROTATE,
			#MOVE
		)
		
		--format "_rollout.display_frames: %\n" _rollout.display_frames
		--format "DIALOG_time_slider_tools: %\n" DIALOG_time_slider_tools
		----format "\n"; print "TrackbarDialogTicker_v._filterTrackbarKeysByCurrentTool()"
		trackbar.filter = if findItem transform_tools toolmode.commandmode > 0 then
			#currentTM
			--#TMOnly 
		else
			--DIALOG_time_slider_tools.display_frames as name
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
		if this.max_win_hwnd == undefined then 
			this.max_win_hwnd = windows.getMAXHWND()
		
		windows.getWindowPos ( this.max_win_hwnd )
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