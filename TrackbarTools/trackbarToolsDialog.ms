
/** Create Trackbar Tools Dialog
 */
function trackbarToolsDialog =
(
	format "\n"; print ".trackbarToolsDialog()"

	
	/* SETUP */
	
	width_groupbox   = 36
 
	width_button	= 36
	width_btn_big	= 84
	height_btn_big	= 40
	width_btn_small	= 24
	buttons_count	= 101 -- 0-nth frame
	
	visible_buttons = animationRange.end.frame - animationRange.start.frame + 1
	format "visible_buttons: %\n" visible_buttons
	format "width_button: %\n" width_button
	
	format "visible_buttons * width_button: %\n" ( visible_buttons * width_button)
	format "width_groupbox * 2: %\n" (width_groupbox * 2)
	
	dialog_width = (visible_buttons * width_button ) + ( width_groupbox * 2 ) + (width_button  ) 
	format "dialog_width: %\n" dialog_width
	
	frame_buttons = buttons_count + 1
	
	
	--margin = 4
	across = frame_buttons + 1
	
	align_slider_to_buttons = 6 -- offset for pixel perfect postion of slider
	
	buttons_margin = 2 * width_button
	
	width_slider	= width_button * buttons_count + ( width_button / 2) + align_slider_to_buttons

	--dialog_width = (width_groupbox * 2) + width_slider + buttons_margin - ( width_button / 2)
	
	dialog_height = 36
	

	
	/* ORIGIN OF CONTROLS  */ 
	pos_x_origin = pos_x = (width_groupbox ) 
	
	pos_y = 0
	
	pos_x_button =  pos_x_origin - ( width_button / 2 )
	
		
	
	--id = #DIALOG_trackbar_tools
	 
	/* DIALOG */
	--Dialog 	    = Dialog_v ("Time Slider Tools") width:(dialog_width + 0 ) ini:(getSourceFileName())
	Dialog 	    = Dialog_v ("Time Slider Tools") width:(dialog_width + 0 )
	
	/* DIALOG EVENTS */ 
	Dialog.Event #OPEN ("ToolsCallback = TrackbarToolsCallback_v("+Dialog.id as string +")")	tooltip:"PRESSED Tooltip"

	/* DIALOG CONTROLS */  
	_Controls   = Dialog.Controls height:256
	--_Button      = _Controls.control #BUTTON "Btn" 
	--
	--_Controls2   = Dialog.Controls group:("Main Controls2 " )
	--_Button      = _Controls2.control #BUTTON "Btn 2" 
	Dialog.addLocal "ToolsCallback" undefined
	--Dialog.addLocal "TrackbarDialogTicker" ("TrackbarDialogTicker_v("+Dialog.id as string +")")
	
	Dialog.addLocal  "TrackbarDialogTicker" ("TrackbarDialogTicker_v("+Dialog.id as string +")")

	Dialog.addLocal "is_playing_now" false
	Dialog.addLocal "slider_time" undefined
	
	
	/*------------------------------------------------------------------------------
		TIMER
	--------------------------------------------------------------------------------*/
	_Timer = _Controls.control #TIMER "Timer" id:#clock interval:500 active:true
	
	--_Timer.Event #TICK ("if trackbarDialogTicker != undefined then ToolsCallback.onTimerTick(is_playing_now)")
	--_Timer.Event #TICK ("TrackbarDialogTicker.onTimerTick(is_playing_now)")

	/*------------------------------------------------------------------------------
		COLORED BAR OT TOP OF DIALOG
	--------------------------------------------------------------------------------*/
	bar   = _Controls.control #imgTag "" id:#status_bar color:red width:dialog_width height:1 across:1 pos:[0,0] visible:false --align:#CENTER
	
	
	/*------------------------------------------------------------------------------
		GROUPBOXES DEFINITION
	------------------------------------------------------------------------------*/
	_left   = _Controls.control #GroupBox "" id:#FRAMES_CONTROLS	width:width_groupbox pos:[ 0, 1 ] across:3
	--_right  = _Controls.control #GroupBox "" id:#PHASE_CONTROLS	width:width_groupbox pos:[ dialog_width - width_groupbox, 1 ]
	
	
	
	/*------------------------------------------------------------------------------
		LEFT GROUPBOX CONTROLS   
	--------------------------------------------------------------------------------*/  
	Play	= _Controls.control #CHECKBUTTON	"P L A Y"	groupbox:_left.id across:1 width:width_groupbox height:height_btn_big offset:[ 0, -16 ] color:COLOR_NAMES[#DARKGREEN]
	--FPS_label	= _Controls.control #LABEL	"FPS"	groupbox:_left.id across:2 align:#LEFT  offset:[ 0, 10 ] 
	--FPS_ddl	= _Controls.control #DROPDOWN	"[FPS]"	groupbox:_left.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:48  offset:[ 0, 8 ] items:#( "24", "12", "6", "4", "2", "1" ) value:4 
	
	--Play.Event #CHANGED "is_playing_now = not is_playing_now"	tooltip:"Play animation"
	
	--FPS_ddl.Event #SELECTED  ("ToolsCallback.setInterval" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--FPS_ddl.Event #ENTERED ("format \"VAL: %\n\"" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	
	/*------------------------------------------------------------------------------
		RIGHT GROUPBOX CONTROLS  
	--------------------------------------------------------------------------------*/ 
	--_Switch	= _Controls.control #BUTTON "J U M P"	groupbox:_right.id across:1 width:width_groupbox height:height_btn_big offset:[ 0, -16 ] 
	--_Phase_label	= _Controls.control #LABEL "PHASE"	groupbox:_right.id across:2 align:#LEFT  offset:[-6, 10 ] tooltip:"Number of frames in phase"
	--_Phase_dropdown	= _Controls.control #DROPDOWN "[Phase]"	groupbox:_right.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:44  offset:[ 0, 8 ] items:( for i = 1 to 10 collect i as string ) height:11
	--
	----_Phase.Event #CHANGED (Dialog.id as string +".clock.interval = EventFired.val as integer" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--_Switch.Event #PRESSED ("ToolsCallback.jumpToPhase(-1)" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--_Switch.Event #RIGHTCLICK ("ToolsCallback.jumpToPhase(1)" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--
	--_Phase_dropdown.Event #SELECTED ("PHASE_LENGTH = EventFired.val" )  --("format \"EventFired: %\n\" EventFired " ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--
	
	/*------------------------------------------------------------------------------
		SLIDER & CONTROLS 
	--------------------------------------------------------------------------------*/

	/* SLIDER */ 
	--_Srart  = _Controls.control #BUTTON "0"	id:#btn_range_start	 width:width_btn_small	height:32	pos:[ pos_x, pos_y + 4 ]	tooltip:"Set Animation range START"
	--_Slider = _Controls.control #SLIDER ""	id:#slider_current_time	 width:width_slider	type:#INTEGER	pos:[ pos_x += width_button - align_slider_to_buttons , pos_y ]  range:[0, buttons_count, 0] ticks:buttons_count
	--_End    = _Controls.control #BUTTON "1"	id:#btn_range_end	 width:width_btn_small	height:32 Start:32	pos:[ pos_x += width_slider - align_slider_to_buttons,  pos_y + 4 ] tooltip:"Set Animation range END\n\nCTRL: Set RANGE END by last button"
	--
	
	/* EVENTS */ 
	--_Slider.Event #CHANGED ("ToolsCallback.setFrame" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	--_Srart.Event #PRESSED	"ToolsCallback.setAnimRange #START ( animationRange.start.frame - 1 )"	tooltip:" - 1 frame"
	--_Srart.Event #RIGHTCLICK	"ToolsCallback.setAnimRange #START ( animationRange.start.frame + 1 )"	tooltip:" + 1 frame"
	
	--_End.Event #PRESSED	"ToolsCallback.setAnimRange #END ( animationRange.end.frame - 1 )"	tooltip:" - 1 frame"
	--_End.Event #RIGHTCLICK	"ToolsCallback.setAnimRange #END ( animationRange.end.frame + 1 )"	tooltip:" + 1 frame"

	 
	/** Get highlight color
	 */
	function getHighlightColor =
	(
		--format "\n"; print ".getHighlightColor()"
	)
	
	
	/* SHIFT BUTTON DOWN */ 
	--pos_y += width_button
	 
	
	/*------------------------------------------------------------------------------
		FRAME BUTTONS
	------------------------------------------------------------------------------*/
	format "FRAME_RANGE: %\n" buttons_count
	for i = 0 to buttons_count do
	(
		i_str = i as string
		
		pos = [ pos_x_button += width_button , pos_y ]
		
		
		
		_Frame_btn = _Controls.control #CHECKBUTTON ( i_str ) id:("btn_frame_"+ i_str ) width:width_button height:width_button pos:pos highlightColor:(if i == 0 then orange else COLOR_NAMES[#DARKGREEN] ) --visible:( i < visible_buttons )
		--_Frame_btn = _Controls.control #CHECKBUTTON ( i_str ) id:("btn_frame_"+ i_str ) width:width_button height:width_button pos:[ 0, 0 ] 	highlightColor:(if i == 0 then orange else COLOR_NAMES[#DARKGREEN] )
		
		
		_Frame_btn.Event #CHANGED ("if keyboard.controlPressed then ToolsCallback.selectObjectsWithKey( "+i_str +") else ToolsCallback.setFrame( "+i_str +")" ) tooltip:("Go to frame Frame.\n\nCTRL: Select objects with key on frame " + i_str )
		
		_Frame_btn.Event #RIGHTCLICK ("frameButtonRcMenu( "+i_str +")" ) tooltip:( "Open menu" )

	)
	
	
	
	/*------------------------------------------------------------------------------
		DIALOG CREATE
	------------------------------------------------------------------------------*/
	--------Dialog.create()
	Dialog.create height:dialog_height width:dialog_width lockWidth:true lockHeight:true style:#()
	--Dialog.create height:dialog_height width:dialog_width lockWidth:true lockHeight:true --style:#()
	Dialog.dock #BOTTOM
	
	--Dialog.register()
	
)
