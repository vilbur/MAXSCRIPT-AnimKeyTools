/* DEV IMPORT */ 
filein( getFilenamePath(getSourceFileName()) + "/../../../../Lib/ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../../../../Lib/ObjectControllerKeys/ObjectControllerKeys.ms"

/** 
  
 */
function getObjectsWithKeys objs which:#( #POSITION, #ROTATION, #SCALE ) =
(
	format "\n"; print ".getObjectsWithKeys()"
		
	
	if classOf which != Array then which = #( which )
	format "which: %\n" which
	/* OBJECTS to process */ 
	
	ObjectsControllerKeys = #()
	
	for obj in objs where ( ObjectControllerKeys = ObjectControllerKeys_v(obj) ).keys_transforms.keys.count > 0 do
	(
		
		tracks_of_keys = for track in ObjectControllerKeys.keys_transforms.keys where (findItem which track) != 0 collect track

		if tracks_of_keys.count > 0 then
			append ObjectsControllerKeys ObjectControllerKeys
		
		--format "tracks_of_keys: %\n" tracks_of_keys
		
		format "ObjectControllerKeys.keys_transforms: %\n" ObjectControllerKeys.keys_transforms.keys
	)
		
	ObjectsControllerKeys --return
	
)


/** Create keys
 */
function insertKeys objs =
(
	--format "\n"; print ".insertKeys()"
	current_time = currentTime.frame as integer
	

	ObjectsControllerKeys = getObjectsWithKeys(objs)
			
	for ObjectControllerKeys in ObjectsControllerKeys do
	--format "ObjectControllerKeys: %\n" ObjectControllerKeys
		 for transfrom_prop in ObjectControllerKeys.keys_transforms.keys do
			--format "%: %\n" transfrom_prop ObjectControllerKeys.keys_transforms[transfrom_prop]
				ObjectControllerKeys.insertKeys transfrom_prop current_time
				
			--for ControllerKeys in ObjectControllerKeys.keys_transforms[transfrom_prop] do
			--format "ControllerKeys: %\n" ControllerKeys
				--ControllerKeys.insertKeys #POSITION current_time
			
		
	--for ObjectControllerKeys in ObjectsControllerKeys do
	--(
	--	
	--	--keys_transforms = ObjectControllerKeys.keys_transforms
	--	--ObjectControllerKeys.obj
	--	format "ObjectControllerKeys.obj: %\n" ObjectControllerKeys.obj
	--	format "\n"
	--	 --for track in keys_transforms.keys do
	--		--keys_transforms[track].insertKeys #POSITION current_time
	--		--format "keys_transforms[%]: %\n" track keys_transforms[track]
	--
	--)
)
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
buttontext:	"Insert key"
toolTip:	"INSERT KEY at current time.\n\nUse selection or all objects if nothing is selected."
icon:	""
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
		
		objs = if selection.count > 0 then selection as Array else objects

		--insertKeys which:which
		insertKeys (objs)
	)
)

--macros.run "_AnimTools" "AnimTools_select_obejcts_with_Keys"