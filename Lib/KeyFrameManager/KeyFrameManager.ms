filein( getFilenamePath(getSourceFileName()) + "/../RigWrapper/RigWrapper.ms" )	--"./../RigWrapper/RigWrapper.ms"

--filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys/ControllerKeys/ControllerKeys.ms" )	--"./../ObjectControllerKeys/ControllerKeys/ControllerKeys.ms"

filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../ObjectControllerKeys/ObjectControllerKeys.ms"
/** Key frame manager
  
  
  @property array objs if undefined use all objects or selection if something is selected 
  
  
  
 */
struct KeyFrameManager_v
(
	/* construct */
	time, -- undefined | #LEFT | #RIGHT | #CURRENT | [ range_start, range_end ]
	
	/* required */
	/* properties */
	objs,
	transforms, -- #( #POSITION, #ROTATION, #SCALE )| #()	-- delete keys of transforms
	properties, --  #BASEOBJECT | #MODIFIERS | true | false	-- delete keys of mods -- only baseobject | modifiers | both | none of mods if false

	current_time,
	
	only_selected = false,
	
	
	--controller_tracks = Dictionary 
	ControllersKeys	= #(), --"./../ObjectControllerKeys/ObjectControllerKeys.ms"


	/* private */
	transform_tracks_all = #( #POSITION, #ROTATION, #SCALE ),
	
	
	/* dependency */
	RigWrapper,
	
	/* reference */
	/* inhered */
	/** Create keys
	 */
	function createKeys objs: transforms: properties: time:  =
	(
		--format "\n"; print "KeyFrameManager_v.createKeys()"
		--if classOf which != Array then which = #( which )
		this.setParameters objs:objs transforms:transforms properties:properties time:time

		lock_bits = Dictionary #( #POSITION, #{1..3} ) #( #ROTATION, #{4..6} ) #( #SCALE, #{7..3} )
		
		for obj in this.objs do
		(
			locked_transforms = getTransformLockFlags obj --{POS_X,POS_Y,POS_Z,ROT_X,ROT_Y,ROT_Z,SCALE_X,SCALE_Y,SCALE_Z}

			ObjectControllerKeys = ObjectControllerKeys_v(obj)

			/* CEATE KEY FOR EACH TRACK */ 
			for transform_track in this.transforms do
				/* IF TRACK IS NOT LOCKED */ 
				if ( locked_transforms * lock_bits[transform_track] ).isEmpty then
					ObjectControllerKeys.createKeys transform_track current_time
		)
					
	),
	
	/** inser keys
	 */
	function insertKeys objs: transforms: properties: time: =
	(
		--format "\n"; print "KeyFrameManager_v.insertKeys()"
		this.setParameters objs:objs transforms:transforms properties:properties time:time

		ObjectsControllerKeys = this.getObjectsControllerKeys(this.objs)
		
		for ObjectControllerKeys in ObjectsControllerKeys do
			for transform_track in ObjectControllerKeys.keys_transforms.keys do
			(
				--format "\n"
				--format "transform_track: %\n" transform_track
				--format "ObjectControllerKeys.keys_transforms[transform_track]: %\n" ObjectControllerKeys.keys_transforms[transform_track]
				keys_of_track = ObjectControllerKeys.getKeys transform_track
				--format "keys_of_track: %: %\n" transform_track keys_of_track
				--format "amax(keys_of_track): %\n" (amax(keys_of_track))
				--format "current_time: %\n" current_time
				--format "TEST: %\n" ( current_time < amax(keys_of_track) )
				
				/* INSERT KEY ONLY BETWEEN OTHER KEYS - do not create key if it is last  */ 
				if current_time < amax(keys_of_track) then
					ObjectControllerKeys.createKeys transform_track current_time
				
			)
	),


	/** Copy keys
	 */
	function copyKeys objs: transforms: properties: time: =
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		--format "\n"; print "KeyFrameManager_v.copyKeys()"

		if phase_length == unsupplied then
			phase_length = if classOf this.time != Point2 then 1 else this.time.y - this.time.x + 1
		
		this.setParameters objs:objs transforms:transforms properties:properties time:time
		
		this.executeCallback #COPY
	),
	
	/** Mirror keys
	 */
	function mirrorKeys objs: transforms: properties: time: =
	(
		--format "\n"; print "KeyFrameManager_v.mirrorKeys()"
		this.setParameters objs:objs transforms:transforms properties:properties time:time
		
		--current_time = currentTime
		
		key_times = if classOf this.time == Point2 then
			for i = this.time[1] to this.time[2] collect i as integer
		else
			#( currentTime.frame as integer )
		
		--RigWrapper = RigWrapper_v key_times:key_times
		--
		--
		--/* ADD OBJECT  TO FLIPPER */ 
		--for obj in this.objs do
		--	RigWrapper.addControllerToFlip (obj)
		--
		--/* MIRROR TRANSFORMS */ 
		--RigWrapper.mirrorControllerTransfroms()
		
		sliderTime = current_time
	),
	
	
	/** get objects with keys of specific type and time
	 */
	function getObjectsWithKeys objs: transforms: properties: time: select_result:true =
	(
		format "\n"; print "KeyFrameManager_v.getObjectsWithKeys()"
		this.setParameters objs:objs transforms:transforms properties:properties time:time

		objects_with_keys = #()
		
		for obj in this.objs do
		(
			key_found = false

			ObjectControllerKeys = ObjectControllerKeys_v(obj)

			--ObjectControllerKeys.list()
			
			/* LOOP EACH TRANSFORM TRACK #( #POSITION, #ROTATION, #SCALE ) */ 
			for transform_type in ObjectControllerKeys.keys_transforms.keys while not key_found where findItem this.transforms transform_type > 0 do
				for ControllerKeys in ObjectControllerKeys.keys_transforms[transform_type] while not key_found do
					for key_time in ControllerKeys.keys while not key_found where this.isKeyMatchTime key_time do 
						key_found = true
			
			/* IF KEY(S) ON SPECIFIC TIME(S) HAS BEEN FOUND */ 
			if key_found then
				append objects_with_keys obj	
		)
		
		--format "objects_with_keys: %\n" objects_with_keys
		
		if select_result then
		(
			if classOf which != Array then which = #( which )
			
			/* OBJECTS to process */ 
	
			where_search = if selection.count > 0 then "SELECTION" else "ALL OBJECTS"
			
			--objs_to_select = for ObjectControllerKeys in ObjectsControllerKeys collect ObjectControllerKeys.obj
			--format "objs_to_select: %\n" objs_to_select
			
			if objs_to_select.count > 0 then
			(
				msg = objs_to_select.count as string + " OBJECTS SELECTED IN " + where_search + " WITH ANIM KEYS: " + arrayToString which
				
				format "%\n" msg
				
				select objs_to_select
			)
			else
				messageBox ( "THERE IS NOT ANY OBJECT IN " + where_search + "\n\nWITH ANIM KEYS OF TYPE:\n\n" + arrayToString which ) title:( toUpper(mode as string ) + " KEYS")
			
		)
		else
			objects_with_keys --return
	),
	
	/** Remove anim keys from selection
	  * 
	  * @param Array objs if undefined then use current selection
	  * 
	  * @param boolean|name|Array transforms	true|false|#POSITION|#ROTATION|#SCALE|#( #POSITION, #ROTATION, #SCALE )
	  * @param boolean|name|Array properties	true|false|#MODIFIERS|#BASEOBJECT|#( #MODIFIERS, #BASEOBJECT )
	 */
	function removeKeys objs: transforms: properties: time: =
	(
		--format "\n"; print "KeyFrameManager_v.removeKeys()"
		--format "TRANSFORMS: %\n" transforms
		--format "properties: %\n" properties

		this.setParameters objs:objs transforms:transforms properties:properties time:time
		--format "this.properties: %\n" this.properties
		--format "this.time: %\n" this.time
		this.executeCallback #DELETE
	),
	
	/** Remove all keys from scene
	 */
	function removeAllKeysFromSceneOrSelection =
	(
		--format "\n"; print "KeyFrameManager_v.removeAllKeysFromSceneOrSelection()"
		 
		function filterCallbackFunction theAnimatable theParent theSubAnimIndex theGrandParent theNode = 
		(       
			if isController theAnimatable do deleteKeys theAnimatable #allKeys
			true
		)
		
		where_to_delete = if selection.count > 0 then "SELECTION" else "SCENE"
		
		if queryBox ("DELETE ALL KEYS FROM "+where_to_delete+" ?") title:"DELETE ALL KEYS" then
			for i in this.objs do deleteKeys i


			--with redraw off
			--(   
			--	trackbar.filter = #all
			--	local filtind = maxops.trackbar.registerFilter filterCallbackFunction undefined "." 1 active:on
			--	disableRefMsgs()
			--	local sel = getCurrentSelection()
			--	select objects
			--	maxops.trackbar.redraw forceRedraw:on
			--	maxops.trackbar.unregisterfilter filtind        
			--	select sel
			--	enableRefMsgs()
			--	--ok
			--)
	),

	/** 
	  
	 */
	function getObjectsControllerKeys objs which:#( #POSITION, #ROTATION, #SCALE ) =
	(
		--format "\n"; print ".getObjectsControllerKeys()"
			
		
		if classOf which != Array then which = #( which )
		--format "which: %\n" which
		/* OBJECTS to process */ 
		
		ObjectsControllerKeys = #()
		
		for obj in objs where ( ObjectControllerKeys = ObjectControllerKeys_v(obj) ).keys_transforms.keys.count > 0 do
		(
			
			tracks_of_keys = for track in ObjectControllerKeys.keys_transforms.keys where (findItem which track) != 0 collect track
	
			if tracks_of_keys.count > 0 then
				append ObjectsControllerKeys ObjectControllerKeys
			
			--format "tracks_of_keys: %\n" tracks_of_keys
			
			--format "ObjectControllerKeys.keys_transforms: %\n" ObjectControllerKeys.keys_transforms.keys
		)
			
		ObjectsControllerKeys --return
		
	),

	private
	
	/** Process 
	 */
	function executeCallback callback =
	(
		--format "\n"; print "KeyFrameManager_v.executeCallback()"
		--format "callback: %\n" callback
		
		for obj in this.objs do
		(
			ObjectControllerKeys = ObjectControllerKeys_v(obj)
			
			/*------------------------------------------------------------------------------
				KEYS OF TRANSFORMS
			--------------------------------------------------------------------------------*/
			
			/* LOOP EACH TRANSFORM TRACK #( #POSITION, #ROTATION, #SCALE ) */ 
			for transform_type in ObjectControllerKeys.keys_transforms.keys where findItem this.transforms transform_type > 0 do
				for ControllerKeys in ObjectControllerKeys.keys_transforms[transform_type] do
					this._processControllerKeys ControllerKeys callback

			
			/*------------------------------------------------------------------------------
				KEYS OF MODS 
			------------------------------------------------------------------------------*/

			if this.properties != false then
			(
				mods_count = ObjectControllerKeys.keys_mods.count

				/* LOOP EACH MOD IN STACK FROM TOP TO BASEOBJECT */ 
				for mod_index = 1 to ObjectControllerKeys.keys_mods.count
					where ( ControllersKeys = ObjectControllerKeys.keys_mods[mod_index] ) != undefined do
					(
						is_baseobject = mod_index == mods_count -- baseobject is last mod inarray

						/* TEST IF RDELTE KEYS OF BOTH or  KEYS OF BASEOBJECT  or KEYS OF MODIFIERS */ 
						if properties == true or ( is_baseobject and properties == #BASEOBJECT ) or ( not is_baseobject and properties == #MODIFIERS ) then -- faster would be test this before loop through mods
							for prop_name in ControllersKeys.keys do
								this._processControllerKeys ControllersKeys[prop_name] callback
					)
			)
		)
	),
	
	/** Process controller keys
	 */
	function _processControllerKeys ControllerKeys callback =
	(
		--format "\n"; print "KeyFrameManager_v._processControllerKeys()"
		--format "% CALLBACK: %\n" ControllerKeys.ctrl callback
		--format "ControllerKeys: %\n" ControllerKeys
		--format "ControllerKeys.keys: %\n" ControllerKeys.keys
		/** Copy key
		 */
		function _copyKey ctrl key_time =
		(
			--format "\n"; print "KeyFrameManager_v._copyKey()"
			
			phase_length = this._getPhaseLenght()
			--format "phase_length: %\n" phase_length
			new_time = ( key_time + phase_length ) as integer
			
			--format "_copyKey % -> %\n" key_time new_time
			
			/* COPY KEY */ 
			with animate on at time new_time
				ctrl.value = at time key_time ctrl.value
		)
		
		
		ctrl = ControllerKeys.ctrl
		
		keys = for key_time in ControllerKeys.keys where this.isKeyMatchTime key_time collect key_time
		
		for i = keys.count to 1 by -1 where ( key_index = getKeyIndex ctrl keys[i] ) > 0 do
		(
			--format "ctrl: %\n" ctrl
			--format "key_index: %\n" key_index
			case callback of
			(
				#DELETE: deleteKey ctrl key_index

				#COPY:   _copyKey ctrl keys[i]
				
				--#MIRROR:   _mirrorKey ctrl key_time
			)
			
		)
		
		/* MESSAGE */ 
		--if keys.count > 0 then
			--FORMAT "% KEYS: %\n" ctrl keys
		
	),
	
	/** Get phase lenght
	 */
	function _getPhaseLenght =
	(
		--format "\n"; print "KeyFrameManager_v._getPhaseLenght()"
		
		(time[2] - time[1] + 1) as integer --return
	),
	
	/** Is key match time
	 */
	function isKeyMatchTime key_time =
	(
		--format "\n"; print "KeyFrameManager_v.isKeyMatchTime()"
		/*------------------------------------------------------------------------------
			BY CURRENT TIME
		--------------------------------------------------------------------------------*/
		if classOf this.time != Point2 then
			case this.time of
			(
				#LEFT:  key_time < currentTime
				#RIGHT: key_time > currentTime
				
				#CURRENT: key_time == currentTime
				
				default: true -- all keys
			)
		else
		/*------------------------------------------------------------------------------
			IS KEY IN TIME RANGE
		--------------------------------------------------------------------------------*/
			key_time >= time.x and key_time <= time.y
		
	),
		
	/** Set parameters
	 */
	function setParameters objs: transforms: properties: time: =
	(
		--format "\n"; print "KeyFrameManager_v.setParameters()"
		--format "objs: %\n" objs
		--format "transforms: %\n" transforms
		--format "properties: %\n" properties
		--format "\n"
		--format "this.transforms: %\n" this.transforms
		--format "this.properties: %\n" this.properties
		
		--format "time: %\n" time
		
		/*------------------------------------------------------------------------------
			OBJECTS
		--------------------------------------------------------------------------------*/
		
		this.objs = case of
		(
			/* use given objects */ 
			( objs != unsupplied ): objs
			
			/* use selection if objs are not defined and selection exists */ 
			( selection.count > 0): selection
			
			/* use all obejcts */ 
			default: objects
		)
		
		this.objs = this.objs as Array
		
		/*------------------------------------------------------------------------------
			TIME
		--------------------------------------------------------------------------------*/
		if time != unsupplied then 
			this.time = time

		
		/*------------------------------------------------------------------------------
			 TRANSFORMS AND PROPERTIES
		--------------------------------------------------------------------------------*/

		if not ( transforms == unsupplied and properties == unsupplied ) then
		(
			/* TRANSFORMS */ 
			if transforms != unsupplied then 
				this.transforms = transforms
		
			/* MODS */ 
			if properties != unsupplied then 
				this.properties = properties
		)
		else /* SET TRANSFORMS AND MODS TO TRUE if both are unsupplied */ 
			this.transforms = this.properties = true
		
		
		/*------ TRANSFORMS ------*/
		
		if classOf this.transforms == BooleanClass then
			/* GET ALL OR ANY OF TRANSFORM TRACKS */ 
			this.transforms = if this.transforms then transform_tracks_all else #() -- TRUE: use all transforms | FALSE: do not use transforms

			
		else if classOf this.transforms != Array then
			/* SET TRANSFROMS TO ARRAY */ 
			this.transforms = #( this.transforms ) -- #( undefinded ) -- this is allowed -- undefined item is sanitized below

			
		/* CONVERT ITEMS TO #NAMES -- remove undefined items also */ 
		this.transforms = for transform_type in this.transforms where transform_type != undefined collect transform_type as name

		
		/*------ PROPERTIES ------*/
		if properties == unsupplied or properties == unsupplied then
			this.properties = false
			
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "KeyFrameManager.onCreate()"
		--format "this.transforms: %\n" this.transforms
		--format "this.properties: %\n" this.properties
		
		current_time = currentTime
	)
)
