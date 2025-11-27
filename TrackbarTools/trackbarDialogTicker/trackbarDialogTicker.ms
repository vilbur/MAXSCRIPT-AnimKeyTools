
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
	
	hwnd_buttons,
		
	hwnd_slider_default,
	
	slider_pos_size,
	
	buttons_size_pos,
	
	slider_default_pos,
	
	maxwin_pos_size = windows.getWindowPos ( windows.getMAXHWND() ),
		
	/* private */
	viewport_bottom_padding = 56,
	--viewport_bottom_padding = 64,
	viewport_width,
	--slider_width,
	
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
		hwnd_buttons = this.getChildWindow "Time Slider Tools"
		hwnd_slider_default = this.getChildWindow "Time Slider"
		--/* SHOW \ HIDE RED STRIP ON TOP OF ROLLOUT IF AINMATION MODE IS ACTIVE */ 
		--_rollout.status_bar.visible = animButtonState
		--
		--format "Dialog: %\n" Dialog
		--format "hwnd_buttons: %\n" hwnd_buttons
		--current_frame = currentTime.frame as integer
		--is_docked =	cui.getDockState _rollout != #cui_floatable
		
		dock_state = if hwnd_slider_default	== undefined then #DOCKED else #UNDOCKED


		if hwnd_slider_default != undefined then 
			slider_default_pos = windows.getWindowPos hwnd_slider_default

		
		if hwnd_buttons == undefined and hwnd_slider_default == undefined then
		(
			cui.UnRegisterDialogBar _rollout
			
			
		)

		
		/* IF NOT DOCKED */ 
		if hwnd_buttons != undefined then
		(
	
			buttons_size_pos = windows.getWindowPos hwnd_buttons


			--format "buttons_size_pos: %\n" buttons_size_pos
			
			
			buttons_size_pos_bak = copy buttons_size_pos
	
			this.setSliderWidth()
			
			this.alignTimeSliders()
			--format "\n"
			--format "buttons_size_pos:   %\n" buttons_size_pos
			--format "slider_default_pos: %\n" slider_default_pos
			if buttons_size_pos != buttons_size_pos_bak then 
				windows.setWindowPos hwnd_buttons buttons_size_pos true
	
			/* SET DEFAULT TIME SLIDER POSITION */ 
			if hwnd_slider_default != undefined then 
				windows.setWindowPos hwnd_slider_default slider_default_pos true
			
		)
		
		/* ENABLE CURRENT FRAME BUTTON */ 
		this.updateButtons(frame)
		
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
		slider_width = case of
		(
			(hwnd_slider_default	!= undefined): slider_default_pos.w
			(hwnd_buttons	!= undefined): buttons_size_pos.w
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
		
		--pos_y = maxwin_pos_size.h - viewport_bottom_padding - buttons_size_pos.h
		--translate buttons_size_pos [ 0, -buttons_size_pos.y + maxwin_pos_size.h ]
		--translate buttons_size_pos [ 0, -buttons_size_pos.y ]
		
		/* RESET WINNDOW TO X POSITION */ 
		--translate buttons_size_pos [ -buttons_size_pos.x, 0 ]
		--format "buttons_size_pos: %\n" buttons_size_pos

		/* FIND LEFT TOP CORNER OF WINDOW ALIGNEND TO CENTER */ 
		--centered_pos = [ maxwin_pos_size.center.x - ( slider_width / 2 ), 0]
		
		--format "buttons_size_pos: %\n" buttons_size_pos
		/* MOVE WINDOW TO CENTERED POSTION */ 
		--translate buttons_size_pos centered_pos
		

		
		if hwnd_slider_default != undefined then
		(
			/* RESET POSITION */ 
			translate buttons_size_pos [ -buttons_size_pos.x, -buttons_size_pos.y ]
		
			--center_position maxwin_pos_size.center.x  - ( -slider_default_pos.w / 2 )
		
			--translate slider_default_pos [ 0, -slider_default_pos.y ]
			
			/* MOVE IT TO BOTTOM */ 
			--translate slider_default_pos [ 0, maxwin_pos_size.h - viewport_bottom_padding - slider_default_pos.h - buttons_size_pos.h ]
	
			--slider_default_pos.h = 95

			translate buttons_size_pos [ slider_default_pos.x, slider_default_pos.bottom ]
			
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
	function updateButtons frame =
	(
		--format "\n"; print "TrackbarDialogTicker_v.updateButtons()"
		
		if buttons == undefined then 
			buttons = this._getFrameButtons()
		--
		frames_in_range = animationRange.end.frame - animationRange.start.frame + 1
		----format "frames_in_range: %\n" frames_in_range
		visible_buttons = for btn in buttons where btn.visible collect btn 
		--format "visible_buttons: %\n" visible_buttons
		--hwnd_slider_default = this.getChildWindow "Time Slider"
		
		
		dialog_width = if hwnd_buttons != undefined then ( windows.getWindowPos hwnd_buttons).w else maxwin_pos_size.w

		buttons_area = dialog_width - 108
		--
		----btn_width = (buttons_area / frames_in_range) as integer
		btn_width = (buttons_area / (frames_in_range ) ) 
		
		pos_x = 54
		
		if visible_buttons[1].text as integer != animationRange.start.frame as integer then
			for i = 1 to buttons.count do
				buttons[i].text = (( animationRange.start.frame + i - 1 ) as integer ) as string
		
		--format "visible_buttons.count: %\n" visible_buttons.count
		--format "frames_in_range: %\n" frames_in_range
		--format "TEST: %\n" (visible_buttons.count != frames_in_range)
			
			--format "\n"	
			--format "visible_buttons.count: %\n" visible_buttons.count
			--format "frames_in_range: %\n" frames_in_range
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
		--hwnd_buttons = this.getChildWindow "Time Slider Tools"
		--hwnd_slider_default = this.getChildWindow "Time Slider"
		
		this.viewport_width = this.setViewportWidth()
	)
)