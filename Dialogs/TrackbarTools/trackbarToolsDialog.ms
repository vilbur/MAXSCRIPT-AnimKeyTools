
/** Create Trackbar Tools Dialog
  
	ALIGN size and position witrh time slider
	
	
	SYNC count of frame buttons with anim range - update visible buttons count
	
	SYNC current frame -> update active button
	
	PLAY ANIMATION -> update active button
  
  
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
	
	dialog_width = (visible_buttons * width_button ) + ( width_groupbox * 2 ) + (width_button  ) 
	
	dialog_height = 36
	

	/* ORIGIN OF CONTROLS  */ 
	pos_x_origin = pos_x = (width_groupbox ) 
	
	pos_y = 0
	
	pos_x_button =  pos_x_origin - ( width_button / 2 )
	
		
	/* DIALOG */
	Dialog 	    = Dialog_v ("Time Slider Tools") width:(dialog_width + 0 ) ini:(getSourceFileName())
	--Dialog 	    = Dialog_v ("Time Slider Tools") width:(dialog_width + 0 )
	
	
	/* DIALOG CONTROLS */  
	_Controls   = Dialog.Controls()

	Dialog.addLocal "ToolsCallback" undefined
	
	Dialog.addLocal  "TrackbarDialogTicker" ("TrackbarDialogTicker_v("+Dialog.id as string +")")

	Dialog.addLocal "is_playing_now" false
	--Dialog.addLocal "frame_buttons" undefined
	
	
	/*------------------------------------------------------------------------------
		DIALOG EVENTS
	--------------------------------------------------------------------------------*/
	Dialog.Event #OPEN ("ToolsCallback = TrackbarToolsCallback_v("+Dialog.id as string +")")
	
	--Dialog.Event #OPEN ("frame_buttons = for ctrl in "+Dialog.id as string +".controls where matchPattern (ctrl as string ) pattern:(\"*btn_frame_*\") collect ctrl")	tooltip:"PRESSED Tooltip"
	
	
	
	/*------------------------------------------------------------------------------
		TIMER
	--------------------------------------------------------------------------------*/
	TIMER_updateDialog	= _Controls.control #TIMER "TIMER_updateDialog"	interval:500 active:true
	TIMER_updateButton	= _Controls.control #TIMER "TIMER_updateActiveButton"	interval:100 active:true
	TIMER_playBack	= _Controls.control #TIMER "TIMER_playBack"	interval:500 active:true
	
	TIMER_updateDialog.Event	#TICK ("TrackbarDialogTicker.updateDialog()")
	TIMER_updateButton.Event	#TICK ("TrackbarDialogTicker.updateActiveButton()")
	TIMER_playBack.Event	#TICK ("TrackbarDialogTicker.playback(is_playing_now)")



	/*------------------------------------------------------------------------------
		ANIM RANGE CONTROLS   
	--------------------------------------------------------------------------------*/  
	
	/* SPINNERS */ 	
	spinner_start = _Controls.control #SPINNER "" id:#SPN_range_start	type:#integer pos:[ 8 , 0 ] range:[-10, 1000, animationRange.start ]	tooltip:"Set anim range START" fieldWidth:26
	spinner_end   = _Controls.control #SPINNER "" id:#SPN_range_end	type:#integer pos:[ 8, 20 ] range:[  0, 1000, animationRange.end ]	tooltip:"Set anim range END" fieldWidth:26
	
	/* BUTTONS */
	btn_start	= _Controls.control #BUTTON	"<>"	id:#BTN_btn_sstart	width:20 height:16 pos:[ 34 , 0 ]	tooltip:"Shift FIRST frame"
	btn_end	= _Controls.control #BUTTON	"<>"	id:#BTN_btn_send	width:20 height:16 pos:[ 34 , 20 ]	tooltip:"Shift LAST frame\n\nALT: Trim END by CURRENT frame"

	
	/* EVENTS SPINNERS */ 	
	spinner_start.Event	#CHANGED "ToolsCallback.setAnimRange START: EventFired.val"	tooltip:"Set anim range START"
	spinner_end.Event	#CHANGED "ToolsCallback.setAnimRange END: EventFired.val"	tooltip:"Set anim range END"
	
	
	/* EVENTS BUTTONS */
	btn_start.Event	#PRESSED	"ToolsCallback.setAnimRange START: ( animationRange.start.frame - 1 )" tooltip:" -1"
	btn_start.Event	#RIGHTCLICK	"ToolsCallback.setAnimRange START: ( animationRange.start.frame + 1 )" tooltip:" +1"

	btn_end.Event	#PRESSED	"ToolsCallback.setAnimRange END: ( animationRange.end.frame - 1 )" tooltip:" -1"
	btn_end.Event	#RIGHTCLICK	"ToolsCallback.setAnimRange END: ( animationRange.end.frame + 1 )" tooltip:" +1"
	


	/*==============================================================================
	
			FRAME BUTTONS
	
	================================================================================*/
		
	for i = 0 to buttons_count do
	(
		i_str = i as string
		
		pos = [ pos_x_button += width_button , pos_y ]
		
		/* CALLBACK */ 
		keep_button_state = " EventFired.control.state = not EventFired.control.state "
		
		if_control_pressed_jump_to_phase = "if keyboard.controlPressed then ("+keep_button_state+"; ToolsCallback.jumpToPhase"
		
		
		/*------------------------------------------------------------------------------
			ADD BUTTON
		--------------------------------------------------------------------------------*/
        _Frame_btn = _Controls.control #CHECKBUTTON ( i_str ) \
                        id:("btn_frame_"+ i_str )	\
                        pos:pos	\
                        width:0	\
                        height:width_button	\
                        visible:true	\
                        border:false	\
                        highlightColor:COLOR_NAMES[#GREEN_DARK]	\
                        tooltip:"CTRL + LMB | RMB: Jump to phase"

		
		
		/* BUTTON EVENTS */ 
		_Frame_btn.Event #CHANGED    ( if_control_pressed_jump_to_phase + "(-1) ) else ToolsCallback.goToFrameOfButton(EventFired.control.text)" ) tooltip:"Go to frame"
		
		_Frame_btn.Event #RIGHTCLICK ( if_control_pressed_jump_to_phase + "(1) )else frameButtonRcMenu()" ) tooltip:"Show Menu"
	)
	
	
	
	/*------------------------------------------------------------------------------
		PLAY BUTTON
	--------------------------------------------------------------------------------*/
	
	--PlayBtn	= _Controls.control #CHECKBUTTON	"P L A Y"	id:#BTN_play width:42 height:(dialog_height) color:COLOR_NAMES[#DARKGREEN]
	PlayBtn	= _Controls.control #CHECKBUTTON	"►"	id:#BTN_play width:52 height:(dialog_height) color:COLOR_NAMES[#DARKGREEN] ini:false
	
    --PlayBtn.Event #CHANGED   	"is_playing_now = not is_playing_now" tooltip:"START \ STOP playback"
    PlayBtn.Event #CHANGED   	"is_playing_now = not is_playing_now; EventFired.control.text = if val then \"■\" else \"►\" " tooltip:"START \ STOP playback"
    PlayBtn.Event #RIGHTCLICK	"ToolsCallback.showFpsRcMenu()"       tooltip:"Set FPS"

	
	/* HOLDER OF FPS VALUE */ 
    _Controls.control #SPINNER "" id:#SPN_FPS_holder type:#integer range:[ 1, 24, 1 ] visible:false

	/*------------------------------------------------------------------------------
		DIALOG CREATE
	------------------------------------------------------------------------------*/

	/* DEVELOPENT */ 
	--Dialog_rollout = Dialog.create height:48 width:dialog_width lockWidth:true lockHeight:true --style:#()

	/* PRODUCTION */ 
	Dialog_rollout = Dialog.create height:36 width:dialog_width lockWidth:true lockHeight:true style:#()
	
	----Dialog.register()
)
