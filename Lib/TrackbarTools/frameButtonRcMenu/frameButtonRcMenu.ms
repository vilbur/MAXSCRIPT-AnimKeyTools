/** Frame button rc menu
  
  AnimLayerManager.setLayerActiveNodes 1 $

  
 */
function frameButtonRcMenu frame =
(
	/** Get int string
	 */
	function getString num = (num as integer )  as string

	transform_tracks = #( "POSITION", "ROTATION", "SCALE" ) 
	format "\n"; print ".frameButtonRcMenu()"
	--format "DIALOG_time_slider_tools.DL_phase.selection: %\n" DIALOG_time_slider_tools.DL_phase.selection
	phase_length = DIALOG_time_slider_tools.DL_phase.items[DIALOG_time_slider_tools.DL_phase.selection] as integer
	
	phase = [ currentTime, currentTime + phase_length - 1 ] 
	format "PAHSE_RANGE: %\n" phase
	time_delete = if keyboard.controlPressed then "#RIGHT" else "#CURRENT"
	KeyFrameManager_side   = "(KeyFrameManager_v( if keyboard.controlPressed then #LEFT else #RIGHT ))"

	/*------------------------------------------------------------------------------
		COMMANDS
	--------------------------------------------------------------------------------*/
	removeKeys_cmd = "(KeyFrameManager_v( "+time_delete+" )).removeKeys "
	copyKeys_cmd   = "(KeyFrameManager_v( "+phase as string +" )).copyKeys "
	mirrorKeys_cmd   = "(KeyFrameManager_v( "+phase as string +" )).mirrorKeys "

	/*------------------------------------------------------------------------------
		HELPERS
	--------------------------------------------------------------------------------*/
	copy_keys_label = " KEYS " + getString (phase.x) + " - " + getString (phase.y)  + " TO: " + getString (phase.y + 1) + " - " + getString (phase.y + phase_length+ 1 )
	
	/*------------------------------------------------------------------------------
		MENU
	--------------------------------------------------------------------------------*/
	Menu = RcMenu_v name:"frameButtonMenu"
	
	if selection.count > 0 then
	(
		Menu.item	"Delete CURRENT KEY"	"(KeyFrameManager_v( #CURRENT )).removeKeys()"
		
		/*------------------------------------------------------------------------------
			TRIM
		--------------------------------------------------------------------------------*/
		Menu.item	"TRIM keys RIGHT • Ctrl: LEFT"	(KeyFrameManager_side+".removeKeys()")
		
		menu_trim = Menu.menu ("TRIM KEYS") --flat:false
		
		menu_trim.item "TRIM ALL TRANSFORMS" ( KeyFrameManager_side + "transforms:true" )
		
		for transform_track in transform_tracks do
			menu_trim.item ("Trim " + transform_track ) ( KeyFrameManager_side+".removeKeys TRANSFORMS:#" + transform_track)
	
			menu_trim.separator()
			
			menu_trim.item ("Trim Properties" ) ( KeyFrameManager_side+".removeKeys()")
		
		Menu.separator()
		
		
		
		/*------------------------------------------------------------------------------
			DELETE TRANSFORMS
		--------------------------------------------------------------------------------*/
		
		
		del_menu = Menu.menu "Delete TRANSFORMS"
	
		/* TRANSFORMS all */
		del_menu.item "Delete ALL TRANSFORMS" ( removeKeys_cmd + "transforms:true" )
		
		
		/* TRANSFORMS each */
		for transform_track in transform_tracks do 
			del_menu.item ("Delete "+transform_track) ( removeKeys_cmd + "transforms:#" + transform_track )
		
		
		
		/*------------------------------------------------------------------------------
			DELETE PROPERTIES
		--------------------------------------------------------------------------------*/
	
		/* PROPERTIES all */
		Menu.item "Delete ALL PROPERTIES" ( removeKeys_cmd + "properties:true" )
		
	
		Menu.separator()
	
		/*------------------------------------------------------------------------------
			COPY KEYS
		--------------------------------------------------------------------------------*/
		
		Menu.item ( "COPY" + copy_keys_label ) ( copyKeys_cmd + " transforms:true" )
		
		Menu.separator()
		
		--
		--/*------------------------------------------------------------------------------
		--	MIRROR
		----------------------------------------------------------------------------------*/
		--Menu.item ( "MIRROR curretnt keys" ) ( "(KeyFrameManager_v( #CURRENT )).mirrorKeys transforms:true" )
		--Menu.item ( "MIRROR" + copy_keys_label ) ( mirrorKeys_cmd + " transforms:true" )
		
	)
	else
	(
		Menu.item "DELETE all keys from scene" "(KeyFrameManager_v( #CURRENT )).removeAllKeysFromScene()"
		
		Menu.item "TRIM all keys from scene RIGHT • Ctrl: LEFT" ( "if queryBox ( \"TRIM keys from all objects in scene ?\") title:\"TRIM keys\" then "+KeyFrameManager_side+".removeKeys objs:( objects as Array )")
	)
	
	
		

	
	--submenu = Menu.menu "COPY KEYS"

	/* SUBMENU TRANSFORMS */
--format "PHASE_LENGTH: %\n" phase_length
	--KeyFrameManager 	= KeyFrameManager_v() --time:#RIGHT -- DELETE CURRENT TIME IF time == undefined 
	
	/* Copy keys in range 1-10 to 11-20 */ 
	--KeyFrameManager.copyKeys time:[ 1, 10 ] transforms:true mods:false -- default increment is length ofrange + 1
	
	/* COPY POSITION KEYS ABOUT 30 FRAMES FORWARD */ 
	--KeyFrameManager.copyKeys time:[ 0, 10 ] increment:30 transforms:#POSITION
	

	
	popUpMenu (Menu.create())
	
	
)
