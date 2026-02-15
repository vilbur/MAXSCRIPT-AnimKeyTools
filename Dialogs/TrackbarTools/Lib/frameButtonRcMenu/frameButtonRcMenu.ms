/** Frame button rc menu
  
  AnimLayerManager.setLayerActiveNodes 1 $

  
 */
function frameButtonRcMenu =
(
	/** Get int string
	 */
	function getString num = ( num as integer ) as string
	
	--which = case toolmode.commandmode of
	--(
	--	#move:	#POSITION
	--	#Rotate:	#ROTATION
	--	#squash:	#SCALE
	--	#nuscale:	#SCALE
	--	#uscale:	#SCALE
	--	default: #( #POSITION, #ROTATION, #SCALE )
	--)
		
	transform_tracks = #( "POSITION", "ROTATION", "SCALE" ) 
	--format "\n"; print ".frameButtonRcMenu()"
	--format "DIALOG_time_slider_tools.DL_phase.selection: %\n" DIALOG_time_slider_tools.DL_phase.selection
	--phase_dll = ROLLOUT_phasemaker_options.DL_phase_length 
	
	--phase_length = phase_dll.items[phase_dll.selection] as integer
	
	phase = [ currentTime, currentTime + PHASE_LENGTH - 1 ] 
	time_option_key = "if keyboard.controlPressed then #RIGHT else if keyboard.altPressed then #LEFT else #CURRENT"
	
	time_current = "(KeyFrameManager_v( #CURRENT ))"
	KeyFrameManager_side    = "(KeyFrameManager_v( if keyboard.controlPressed then #LEFT else #RIGHT ))"

	/*------------------------------------------------------------------------------
		COMMANDS
	--------------------------------------------------------------------------------*/
	
	removeKeys = "(KeyFrameManager_v( "+time_option_key+" )).removeKeys "
	copyKeys   = "(KeyFrameManager_v( "+phase as string +" )).copyKeys "
	mirrorKeys = "(KeyFrameManager_v( "+phase as string +" )).mirrorKeys "

	/*------------------------------------------------------------------------------
		HELPERS
	--------------------------------------------------------------------------------*/
	copy_keys_label = " KEYS " + getString (phase.x) + " - " + getString (phase.y)  + " TO: " + getString (phase.y + 1) + " - " + getString (phase.y + phase_length+ 1 )
	
	/*------------------------------------------------------------------------------
		MENU
	--------------------------------------------------------------------------------*/
	Menu = RcMenu_v name:"frameButtonMenu"

	
	/*==============================================================================
		MENU IF SELECTION EXISTS
	================================================================================*/
	if selection.count > 0 then
	(
		Menu.item	"CREATE  Keys"	(time_current + ".createKeys()" )

		Menu.separator()

		Menu.item	"INSRERT Keys"	(time_current + ".insertKeys()" )

		Menu.separator()
		
		
		/*------------------------------------------------------------------------------
			DELETE \ TRIM KEYS
		--------------------------------------------------------------------------------*/
		
		
		del_menu = Menu.menu "DELETE KEYS"
		
		del_menu.item	"All KEYS"	(removeKeys + "()" )
		
		/* TRANSFORMS all */
		del_menu.item "TRANSFORMS" ( removeKeys + " transforms:true" )
		del_menu.item "PROPERTIES" ( removeKeys + " properties:true" )
		
		del_menu.separator() 
		
		/* TRANSFORMS each */
		for transform_track in transform_tracks do 
			del_menu.item ("Delete "+transform_track) ( removeKeys + "transforms:#" + transform_track )
		
		
		del_menu.separator()
		
		del_menu.item	"• Ctrl: RIGHT | Alt: LEFT" "messageBox \"If CONTROL pressed then process keys to RIGHT\n    If ALT pressed then process keys to LEFT\" title:\"HELP\""

		/*------------------------------------------------------------------------------
			DELETE PROPERTIES
		----------------------------------------------------------------------------------*/
		--
		--/* PROPERTIES all */
		--Menu.item "Delete ALL PROPERTIES" ( removeKeys + "properties:true" )
		--
		--
		--Menu.separator()
		--
		--/*------------------------------------------------------------------------------
		--	COPY KEYS
		----------------------------------------------------------------------------------*/
		--
		--Menu.item ( "COPY" + copy_keys_label ) ( copyKeys + " transforms:true" )
		--
		--/*------------------------------------------------------------------------------
		--	MIRROR
		----------------------------------------------------------------------------------*/
		--Menu.item ( "MIRROR curretnt keys" ) ( "(KeyFrameManager_v( #CURRENT )).mirrorKeys transforms:true" )
		--Menu.item ( "MIRROR" + copy_keys_label ) ( mirrorKeys + " transforms:true" )


	)
	else
	/*==============================================================================
		MENU IF NOTHING SELECTED
	================================================================================*/
	(
		Menu.item "DELETE all keys from scene" "(KeyFrameManager_v( #CURRENT )).removeAllKeysFromScene()"
		
		Menu.item "TRIM all keys from scene RIGHT | Ctrl: LEFT" ( "if queryBox ( \"TRIM keys from all objects in scene ?\") title:\"TRIM keys\" then "+KeyFrameManager_side+".removeKeys objs:( objects as Array )")
	)
	
	
	
	Menu.separator()

	/*------------------------------------------------------------------------------
		SELECT OBJECTS
	--------------------------------------------------------------------------------*/

	menu_trim = Menu.menu ( ( if selection.count > 0 then "FILTER" else "SELECT") + " by keys") --flat:false

	menu_trim.item ( "On frame " + (currentTime.frame as integer ) as string ) (KeyFrameManager_side+".getObjectsWithKeys time:#CURRENT")

	menu_trim.item ( "With keys to RIGHT | Ctrl: LEFT") (KeyFrameManager_side+".getObjectsWithKeys()")
	
	
	--submenu = Menu.menu "COPY KEYS"

	/* SUBMENU TRANSFORMS */
--format "PHASE_LENGTH: %\n" phase_length
	--KeyFrameManager 	= KeyFrameManager_v() --time:#RIGHT -- DELETE CURRENT TIME IF time == undefined 
	
	/* Copy keys in range 1-10 to 11-20 */ 
	--KeyFrameManager.copyKeys time:[ 1, 10 ] transforms:true mods:false -- default increment is length ofrange + 1
	
	/* COPY POSITION KEYS ABOUT 30 FRAMES FORWARD */ 
	--KeyFrameManager.copyKeys time:[ 0, 10 ] increment:30 transforms:#POSITION

	
	Menu.popUp()
)