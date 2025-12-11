/* DEV IMPORT */ 
--filein( getFilenamePath(getSourceFileName()) + "/../../../../Lib/ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../../../../Lib/ObjectControllerKeys/ObjectControllerKeys.ms"


/**  
 */
macroscript	AnimTools_select_obejcts_with_Keys
category:	"_AnimTools"
buttontext:	"Select by keys"
toolTip:	"Select objects with anim keys.\n\nSearch in selection or all objects if nothing is selected.\n\nType of keys is driven by current tool.\n\n1) DEFAULT: ALL TYPES OF TRANSFORM KEYS\n\n2) MOVE: POSIITON\n\n3) ROTATE: ROTATION\n\n4) SCALE: SCALE"
icon:	"across:2|width:96|height:32"
(
	on execute do
	(
		/** Join array to string
		 */
		function arrayToString arr delimeter:" " = ( _string = ""; for item in arr do _string += toUpper(item as string ) + delimeter; substring _string 1 (_string.count-delimeter.count))
		
		
		which = case toolmode.commandmode of
		(
			#move:	#POSITION
			#Rotate:	#ROTATION
			#squash:	#SCALE
			#nuscale:	#SCALE
			#uscale:	#SCALE
			default: #( #POSITION, #ROTATION, #SCALE )
		)
		
		objs = if selection.count > 0 then selection as Array else objects

		ObjectsControllerKeys = getObjectsWithKeys objs which:which
		
		if classOf which != Array then which = #( which )
		
		/* OBJECTS to process */ 

		where_search = if selection.count > 0 then "SELECTION" else "ALL OBJECTS"
		
		objs_to_select = for ObjectControllerKeys in ObjectsControllerKeys collect ObjectControllerKeys.obj
		format "objs_to_select: %\n" objs_to_select
		
		if objs_to_select.count > 0 then
			select objs_to_select
		
		else
			messageBox ( "THERE IS NOT ANY OBJECT IN " + where_search + "\n\nWITH ANIM KEYS OF TYPE:\n\n" + arrayToString which ) title:( toUpper(mode as string ) + " KEYS")
	
	)
)

/**  
 */
macroscript	AnimTools_createKeys
category:	"_AnimTools"
buttontext:	"createKeys"
toolTip:	"INSERT KEY at current time.\n\nUse selection or all objects if nothing is selected."
icon:	"menu:Insert key"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-AnimKeyTools\AnimTools\content\rollouts-main\rollout-KEYS\[Manage keys].mcr"
		--which = case toolmode.commandmode of
		--(
		--	#move:	#POSITION
		--	#Rotate:	#ROTATION
		--	#squash:	#SCALE
		--	#nuscale:	#SCALE
		--	#uscale:	#SCALE
		--	default: #( #POSITION, #ROTATION, #SCALE )
		--)
		
		format "\nInsert key"
		--createKeys()
		--createKeys tracks:#POSITION
		createKeys tracks:#ROTATION
	)
)
/**  
 */
macroscript	AnimTools_test
category:	"_AnimTools"
buttontext:	"TEST"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-AnimKeyTools\AnimTools\content\rollouts-main\rollout-KEYS\[Manage keys].mcr"
		--which = case toolmode.commandmode of
		--(
		--	#move:	#POSITION
		--	#Rotate:	#ROTATION
		--	#squash:	#SCALE
		--	#nuscale:	#SCALE
		--	#uscale:	#SCALE
		--	default: #( #POSITION, #ROTATION, #SCALE )
		--)
		MenuRc = RcMenu_v name:menu_name

MenuRc.loadMenu "_AnimTools"

--MenuRc.loadMenu "menu_name"

/** POP UP MENU ON MOUSE POS
 *
 */
MenuRc.popUp()

				
		--
		----insertKeys which:which
		--insertKeys (objs)
	)
)

--macros.run "_AnimTools" "AnimTools_select_obejcts_with_Keys"