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
