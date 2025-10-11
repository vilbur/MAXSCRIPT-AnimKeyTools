
/** Create Trackbar Tools Dialog
 */
function trackbarToolsDialog =
(
	format "\n"; print ".trackbarToolsDialog()"

	
	/* SETUP */
	
	width_groupbox   = 96
	width_groupbox_2 = width_groupbox * 2
 
	width_button	= 36
	width_btn_big	= 84
	height_btn_big	= 40
	width_btn_small	= 24
	frame_range	= 16 -- 0-16th frame
	frame_buttons = frame_range + 1
	
	
	--margin = 4
	across = frame_buttons + 1
	
	align_slider_to_buttons = 6 -- offset for pixel perfect postion of slider
	
	buttons_margin = 2 * width_button
	
	width_slider	= width_button * frame_range + ( width_button / 2) + align_slider_to_buttons

	dialog_width = width_groupbox_2 + width_slider + buttons_margin - ( width_button / 2)
	
	dialog_height = 80
	
	--id = #DIALOG_trackbar_tools
	 
	/* DIALOG */
	Dialog 	    = Dialog_v ("Time Slider Tools") width:(dialog_width + 0 ) ini:(getSourceFileName())
	--Dialog 	    = Dialog_v ("Test") --ini:(getSourceFileName())
	
	Dialog.Event #OPEN ("TimeTools = TrackbarTools_v("+Dialog.id as string +")")	tooltip:"PRESSED Tooltip"

	/* DIALOG CONTROLS */  
	_Controls   = Dialog.Controls height:256
	--_Button      = _Controls.control #BUTTON "Btn" 
	--
	--_Controls2   = Dialog.Controls group:("Main Controls2 " )
	--_Button      = _Controls2.control #BUTTON "Btn 2" 
	Dialog.addLocal "TimeTools" undefined
	
	Dialog.addLocal "is_playing_now" false
	
	_Timer = _Controls.control #TIMER "Timer" id:#clock interval:500 active:true
	_Timer.Event #TICK ("if TimeTools != undefined then TimeTools.onTimerTick(is_playing_now)")

	bar   = _Controls.control #imgTag "" id:#status_bar color:red width:dialog_width height:1 across:1 pos:[0,0] visible:false --align:#CENTER
	
	
	/*------------------------------------------------------------------------------
		GROUPBOX 
	------------------------------------------------------------------------------*/
	_left   = _Controls.control #GroupBox "" id:#FRAMES_CONTROLS	width:width_groupbox pos:[ 0, 1 ] across:3
	_right  = _Controls.control #GroupBox "" id:#PHASE_CONTROLS	width:width_groupbox pos:[ dialog_width - width_groupbox, 1 ]
	
	
	
	/*------------------------------------------------------------------------------
		LEFT GROUPBOX 
	--------------------------------------------------------------------------------*/ 
	Play	= _Controls.control #CHECKBUTTON	"P L A Y"	groupbox:_left.id across:1 width:width_btn_big height:height_btn_big offset:[ 0, -16 ] color:COLOR_NAMES[#DARKGREEN]
	FPS_label	= _Controls.control #LABEL	"FPS"	groupbox:_left.id across:2 align:#LEFT  offset:[ 0, 10 ] 
	FPS_ddl	= _Controls.control #DROPDOWN	"[FPS]"	groupbox:_left.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:48  offset:[ 0, 8 ] items:#( "24", "12", "6", "4", "2", "1" ) value:4 
	
	Play.Event #CHANGED "is_playing_now = not is_playing_now"	tooltip:"Play animation"
	
	FPS_ddl.Event #SELECTED  ("TimeTools.setInterval" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--FPS_ddl.Event #ENTERED ("format \"VAL: %\n\"" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	
	/*------------------------------------------------------------------------------
		RIGHT GROUPBOX
	--------------------------------------------------------------------------------*/
	_Switch	= _Controls.control #BUTTON "J U M P"	groupbox:_right.id across:1 width:width_btn_big height:height_btn_big offset:[ 0, -16 ] 
	_Phase_label	= _Controls.control #LABEL "PHASE"	groupbox:_right.id across:2 align:#LEFT  offset:[-6, 10 ] tooltip:"Number of frames in phase"
	_Phase_dropdown	= _Controls.control #DROPDOWN "[Phase]"	groupbox:_right.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:44  offset:[ 0, 8 ] items:( for i = 1 to 10 collect i as string ) value:2 height:11
	
	--_Phase.Event #CHANGED (Dialog.id as string +".clock.interval = EventFired.val as integer" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	_Switch.Event #PRESSED ("TimeTools.jumpToPhase(-1)" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	_Switch.Event #RIGHTCLICK ("TimeTools.jumpToPhase(1)" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	
	_Phase_dropdown.Event #SELECTED ("TimeTools.updateButtons(sliderTime.frame)" )  --("format \"EventFired: %\n\" EventFired " ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	
	/*------------------------------------------------------------------------------
		ORIGIN OF CONTROLS 
	--------------------------------------------------------------------------------*/
	pos_x_origin = pos_x = width_groupbox + 4
	
	pos_y = 4
	
	
	pos_x_button =  pos_x_origin - ( width_button / 2 )
	
	
	
	/*------------------------------------------------------------------------------
		SLIDER & CONTROLS 
	--------------------------------------------------------------------------------*/
	_Srart  = _Controls.control #BUTTON "0"	id:#btn_range_start	 width:width_btn_small	height:32	pos:[ pos_x, pos_y + 4 ]	tooltip:"Set Animation range START"
	_Slider = _Controls.control #SLIDER ""	id:#slider_current_time	 width:width_slider	type:#INTEGER	pos:[ pos_x += width_button - align_slider_to_buttons , pos_y ]  range:[0, frame_range, 0] ticks:frame_range
	_End    = _Controls.control #BUTTON "1"	id:#btn_range_end	 width:width_btn_small	height:32 Start:32	pos:[ pos_x += width_slider - align_slider_to_buttons,  pos_y + 4 ] tooltip:"Set Animation range END\n\nCTRL: Set RANGE END by last button"
	
	/* EVENTS */ 
	_Slider.Event #CHANGED ("TimeTools.setFrame" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	_Srart.Event #PRESSED	"TimeTools.setAnimRange #START ( animationRange.start.frame - 1 )"	tooltip:" - 1 frame"
	_Srart.Event #RIGHTCLICK	"TimeTools.setAnimRange #START ( animationRange.start.frame + 1 )"	tooltip:" + 1 frame"
	
	_End.Event #PRESSED	"TimeTools.setAnimRange #END ( animationRange.end.frame - 1 )"	tooltip:" - 1 frame"
	_End.Event #RIGHTCLICK	"TimeTools.setAnimRange #END ( animationRange.end.frame + 1 )"	tooltip:" + 1 frame"

	 
	/** Get highlight color
	 */
	function getHighlightColor =
	(
		--format "\n"; print ".getHighlightColor()"
	)
	
	
	/* SHIFT BUTTON DOWN */ 
	pos_y += width_button
	
	 
	
	/*------------------------------------------------------------------------------
		FRAME BUTTONS
	------------------------------------------------------------------------------*/
	for i = 0 to frame_range do
	(
		i_str = i as string
		
		_Frame_btn = _Controls.control #CHECKBUTTON ( i_str ) id:("btn_frame_"+ i_str ) width:width_button height:width_button pos:[ pos_x_button += width_button , pos_y ] highlightColor:(if i == 0 then orange else COLOR_NAMES[#DARKGREEN] )
		
		
		_Frame_btn.Event #CHANGED ("if keyboard.controlPressed then TimeTools.selectObjectsWithKey( "+i_str +") else TimeTools.setFrame( "+i_str +")" ) tooltip:("Go to frame Frame.\n\nCTRL: Select objects with key on frame " + i_str )
		
		_Frame_btn.Event #RIGHTCLICK ("frameButtonRcMenu( "+i_str +")" ) tooltip:( "Open menu" )

	)
	
	
	
	/*------------------------------------------------------------------------------
		DIALOG CREATE
	------------------------------------------------------------------------------*/
	--------Dialog.create()
	Dialog.create height:dialog_height lockWidth:true lockHeight:true
	
	Dialog.register()
)
