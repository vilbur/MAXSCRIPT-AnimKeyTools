
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
	--buttons = Dictionary #INTEGER,
	buttons,
	/* private */
	green_color = COLOR_NAMES[#GREEN_DARK], -- coor active frame button 
	
	anim_button_state,
	
	buttons_hwnd,
	
	buttons_size_pos,
		
	slider_hwnd,
	
	slider_pos_size,
	
	maxwin_pos_size = windows.getWindowPos ( windows.getMAXHWND() ),
		
	/* private */
	viewport_bottom_padding = 56,
	--viewport_bottom_padding = 64,
	viewport_width,
	slider_width,
	
	dock_state,
	
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
		--format "\n\n"; print "TrackbarDialogTicker_v.onTimerTick()"
		buttons_hwnd = this.getChildWindow "Time Slider Tools"
		slider_hwnd = this.getChildWindow "Time Slider"
		--/* SHOW \ HIDE RED STRIP ON TOP OF ROLLOUT IF AINMATION MODE IS ACTIVE */ 
		--_rollout.status_bar.visible = animButtonState
		--
		slider_docked  = slider_hwnd  == undefined 
		buttons_docked = buttons_hwnd == undefined 
		
		if slider_hwnd == undefined then
		(
			--format "slider_hwnd: %\n" slider_hwnd
			hwnd = (for control in ( windows.getChildrenHWND #max ) where control[5] == "TimeSlider" collect control[1])[1]

			--format "hwnd: %\n" hwnd
			
		)
		
		if buttons_hwnd != undefined then 
			buttons_size_pos = windows.getWindowPos buttons_hwnd


		if slider_hwnd != undefined then 
			slider_pos_size = windows.getWindowPos slider_hwnd

			
			
			
		
		update_buttons = false

		chenage_window_position = true

		buttons_size_pos_bak = copy buttons_size_pos
		
		/* SET WIDTH OF SLIDER */ 
		this.setSliderWidth()

		/* IF SLIDER DOCKED */ 
		if slider_docked then
		(
			if not buttons_docked then
			(
				--slider_width -= 32
			
				cui.RegisterDialogBar _rollout style:#(#cui_dock_bottom)
				
				cui.DockDialogBar _rollout #cui_dock_bottom
				
				--chenage_window_position = false
				
				update_buttons = true
			)
		)
		
		/* IF SLIDER UN-DOCKED */ 
		if not slider_docked then
		(
			--format "\nSLIDER UN-DOCKED"
			this.alignTimeSliders()
			
			/* IF BUTTONS UN-DOCKED */ 
			if buttons_docked then
			(
				cui.UnRegisterDialogBar _rollout

				buttons_hwnd = this.getChildWindow "Time Slider Tools"
			)

			if buttons_size_pos != buttons_size_pos_bak then

			/* SET POSITION OF BUTTONS WINDOW */ 
			windows.setWindowPos buttons_hwnd buttons_size_pos true

			--	/* SET DEFAULT TIME SLIDER POSITION */ 
			--windows.setWindowPos slider_hwnd slider_pos_size true
	
			update_buttons = true
		)
		
		--if update_buttons then
			this.updateButtons(update_buttons)
		
		
		--CompleteRedraw()
		--/* UPDATE CURRENT FRAME */ 
		--if not is_playing_now then
		--(
		--	--_rollout.slider_time = sliderTime.frame
		--
		--	--if this._sliderValue() != sliderTime.frame then
		--	if _rollout.slider_time != sliderTime.frame then
		--		this.setFrame sliderTime.frame
		--
		--	_rollout.slider_time = sliderTime.frame
		--	
		--)
		----else /* SET NEXT FRAME OF PALYING ANIMATION */ 
		----	this.setNextFrame()
		--	
		--	
		--/*
		--	AUTO FILTER KEYS ON TIME SLIDER
		--  
		--	https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-5120D063-E771-4700-98FF-60E4E578BE52
		--*/ 
		--trackbar.filter = if toolmode.commandmode == #ROTATE or toolmode.commandmode == #MOVE then
		--	--#currentTM
		--	#TMOnly 
		--else
		--	#all
		--
		--	
		--/* SYNC WITH GLOBAL VAROABLE */
		----if PHASE_LENGTH != _rollout.DL_phase.selected as integer then
		----	_rollout.DL_phase.selection = PHASE_LENGTH
		----
		--
		--/* IF STATE OF ANIMATION MODE IS CHANGED */ 
		--if anim_button_state != animButtonState then
		--(
		--	anim_button_state = animButtonState
		--	
		--	/* UPDATE HIGHLIGH COLOR OF BUTTON */ 
		--	if ( frame_button = this._getFrameButton current_frame ) != undefined then
		--	(
		--		frame_button.highlightColor = (this.getFrameButtonColor current_frame)
		--
		--		frame_button.state = false
		--		frame_button.state = true
		--	)
		--)

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
		
		/* SET WINDOW WIDTH */ 
		buttons_size_pos.w = slider_width
	),
	
	
	
	
	/** Align time sliders
	 */
	function alignTimeSliders =
	(
		--format "\n"; print "TrackbarToolsCallback_v.alignTimeSliders()"
		
		/* FIND LEFT TOP CORNER OF WINDOW ALIGNEND TO CENTER */ 
		--centered_pos = [ maxwin_pos_size.center.x - ( slider_width / 2 ), 0]
		--/* MOVE WINDOW TO CENTERED POSTION */ 
		
		
		if slider_hwnd != undefined then
		(
			/* RESET POSITION */ 
			translate buttons_size_pos [ -buttons_size_pos.x, -buttons_size_pos.y ]
		--format "buttons_size_pos: %\n" buttons_size_pos
		--format "slider_pos_size: %\n" slider_pos_size
			--center_position maxwin_pos_size.center.x  - ( -slider_pos_size.w / 2 )
		
			--translate slider_pos_size [ 0, -slider_pos_size.y ]
			
			/* MOVE IT TO BOTTOM */ 
			--translate slider_pos_size [ 0, maxwin_pos_size.h - viewport_bottom_padding - slider_pos_size.h - buttons_size_pos.h ]
	
			--slider_pos_size.h = 95

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
	function updateButtons update_buttons =
	(
		--format "\n"; print "TrackbarDialogTicker_v.updateButtons()"
		
		if buttons == undefined then 
			buttons = this._getFrameButtons()
		
		
		frames_in_range = animationRange.end.frame - animationRange.start.frame + 1

		visible_buttons = for btn in buttons where btn.visible collect btn 


		if update_buttons or visible_buttons.count != frames_in_range then
		(
			buttons_area = slider_width - 108

			if slider_hwnd == undefined then
				buttons_area -= 20
			
			btn_width = (buttons_area / (frames_in_range ) ) 
	
			pos_x = 54
			
			if visible_buttons[1].text as integer != animationRange.start.frame as integer then
				for i = 1 to buttons.count do
					buttons[i].text = (( animationRange.start.frame + i - 1 ) as integer ) as string
		
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
	/** Get frame buttons
	  
	  @return Dictionary #INTEGER
	 */
	function _getFrameButtons =
	(
		--format "\n"; print "._getFrameButtons()"
		--buttons	=  Dictionary #INTEGER
		----format "_rollout.controls: %\n" _rollout.controls
		----for ctrl in _rollout.controls do
		----format "ctrl: %\n" ctrl
		--
		----buttons = for ctrl in _rollout.controls where matchPattern ctrl.name pattern:("btn_frame_*") collect ctrl
		--only_frame_buttons = for ctrl in _rollout.controls where matchPattern (ctrl as string ) pattern:("*btn_frame_*") collect ctrl
		--
		--for i = 0 to only_frame_buttons.count - 1 collect buttons[i] = only_frame_buttons[i +1]
		--
		--buttons --return
		
		for ctrl in _rollout.controls where matchPattern (ctrl as string ) pattern:("*btn_frame_*") collect ctrl --return
	),

	/** Get height of maximized viewport to find out height of docked dialog
	 */
	function setViewportWidth =
	(
		--print "Dialog_v._getViewportHeight()"
		is_maximized	= viewport.numViews == 1

		height_of_ui	= 0 -- Add heigh
		dialog_title_height	= 30

		--if( trackbar.visible ) then
		--	height_of_ui	+= 27
		--
		--if( timeSlider.isVisible() ) then
		--	height_of_ui	+= 18

		if not( is_maximized ) then
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle

		viewport_width = getViewSize()
		--format "viewport_area_size	= % \n" viewport_area_size
		if not( is_maximized ) then
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle

	),

	on create do
	(
		--format "\n"; print "TrackbarDialogTicker_v.onCreate()"
		--buttons_hwnd = this.getChildWindow "Time Slider Tools"
		--slider_hwnd = this.getChildWindow "Time Slider"
		
		this.viewport_width = this.setViewportWidth()
	)
)