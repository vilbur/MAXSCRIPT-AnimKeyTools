/* DEV IMPORT */ 
--filein( getFilenamePath(getSourceFileName()) + "/../../../../Lib/ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../../../../Lib/ObjectControllerKeys/ObjectControllerKeys.ms"

/** 
  
  @param name mode #SELECT|#DELETE
  
  
 */
function selectObjectsOrDeleteKeys mode:#SELECT which:#( #POSITION, #ROTATION, #SCALE ) =
(
	format "\n"; print ".selectObjectsOrDeleteKeys()"
	
	/** Join array to string
	 */
	function arrayToString arr delimeter:" " = ( _string = ""; for item in arr do _string += toUpper(item as string ) + delimeter; substring _string 1 (_string.count-delimeter.count))
	
	if classOf which != Array then which = #( which )
	format "which: %\n" which
	/* OBJECTS to process */ 
	objs = if selection.count > 0 then selection as Array else objects
	
	where_search = if selection.count > 0 then "SELECTION" else "ALL OBJECTS"
	
	objs_with_key = #()
	
	for obj in objs where ( ObjectControllerKeys = ObjectControllerKeys_v(obj) ).keys_transforms.keys.count > 0 do
	(
		
		tracks_of_keys = for track in ObjectControllerKeys.keys_transforms.keys where (findItem which track) != 0 collect track

		if tracks_of_keys.count > 0 then
			append objs_with_key ObjectControllerKeys
		
		--format "tracks_of_keys: %\n" tracks_of_keys
		
		format "ObjectControllerKeys.keys_transforms: %\n" ObjectControllerKeys.keys_transforms.keys
	)
	
	format "\nobjs_with_key: %\n" objs_with_key
	
	
	if mode == #SELECT then
	(
		objs_to_select = for ObjectControllerKeys in objs_with_key collect ObjectControllerKeys.obj
		format "objs_to_select: %\n" objs_to_select
		if objs_to_select.count > 0 then
			select objs_to_select
		
		else
			messageBox ( "THERE IS NOT ANY OBJECT IN " + where_search + "\n\nWITH ANIM KEYS OF TYPE:\n\n" + arrayToString which ) title:( toUpper(mode as string ) + " KEYS")
		
	)
)

/**  
 */
macroscript	AnimTools_select_obejcts_with_Keys
category:	"_AnimTools"
buttontext:	"Select by keys"
toolTip:	"Select objects with anim keys.\n\nSearch in selection or all objects if nothing is selected.\n\nType of keys is driven by current tool.\n\n1) DEFAULT: ALL TYPES OF TRANSFORM KEYS\n\n2) MOVE: POSIITON\n\n3) ROTATE: ROTATION\n\n4) SCALE: SCALE"
(
	on execute do
	(
		which = case toolmode.commandmode of
		(
			#move:	#POSITION
			#Rotate:	#ROTATION
			#squash:	#SCALE
			#nuscale:	#SCALE
			#uscale:	#SCALE
			default: #( #POSITION, #ROTATION, #SCALE )
		)
		
		selectObjectsOrDeleteKeys which:which
	)
)

--macros.run "_AnimTools" "AnimTools_select_obejcts_with_Keys"