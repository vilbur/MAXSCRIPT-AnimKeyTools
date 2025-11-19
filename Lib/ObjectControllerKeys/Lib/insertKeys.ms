

/** Create keys
 */
function insertKeys =
(
	--format "\n"; print ".insertKeys()"
	current_time = currentTime.frame as integer
	
	objs = if selection.count > 0 then selection as Array else objects
	
	ObjectsControllerKeys = getObjectsWithKeys(objs)
			
	for ObjectControllerKeys in ObjectsControllerKeys do

		 for transfrom_prop in ObjectControllerKeys.keys_transforms.keys do

				ObjectControllerKeys.insertKeys transfrom_prop current_time
				
)