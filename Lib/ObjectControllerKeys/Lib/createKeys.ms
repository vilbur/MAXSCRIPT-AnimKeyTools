
/** Create keys
 */
function createKeys tracks:#( #POSITION, #ROTATION, #SCALE )  =
(
	--format "\n"; print ".createKeys()"
	--if classOf which != Array then which = #( which )
	
	if classOf tracks != Array then tracks = #( tracks )

	current_time = currentTime.frame as integer

	objs = if selection.count > 0 then selection as Array else objects
	
	--ObjectsControllerKeys = getObjectsWithKeys(objs)
	for obj in objs do
	(
		ObjectControllerKeys = ObjectControllerKeys_v(obj)
		
		 for transform_track in tracks do

				ObjectControllerKeys.createKeys transform_track current_time
	)
	--for ObjectControllerKeys in ObjectsControllerKeys do

				
)