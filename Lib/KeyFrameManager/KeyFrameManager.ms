filein( getFilenamePath(getSourceFileName()) + "/../RigWrapper/RigWrapper.ms" )	--"./../RigWrapper/RigWrapper.ms"

--filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys/ControllerKeys/ControllerKeys.ms" )	--"./../ObjectControllerKeys/ControllerKeys/ControllerKeys.ms"

filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../ObjectControllerKeys/ObjectControllerKeys.ms"
/** Key frame manager
 */
struct KeyFrameManager_v
(
	/* construct */
	time, -- undefined | #LEFT | #RIGHT | #CURRENT | [ range_start, range_end ]
	
	/* required */
	/* properties */
	objs,
	transforms, -- #( #POSITION, #ROTATION, #SCALE )| @()
	properties,

	current_time,
	
	only_selected = false,
	
	transform_tracks_all = #( #POSITION, #ROTATION, #SCALE ),
	
	--controller_tracks = Dictionary 
	ControllersKeys	= #(),


	/* private */
	/* dependency */
	RigWrapper,
	
	/* reference */
	/* inhered */
	
	
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
		
		current_time = currentTime
		
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
	
	/** Remove all keys from scene
	 */
	function removeAllKeysFromScene =
	(
		--format "\n"; print "KeyFrameManager_v.removeAllKeysFromScene()"
		 
		function filterCallbackFunction theAnimatable theParent theSubAnimIndex theGrandParent theNode = 
		(       
			if isController theAnimatable do deleteKeys theAnimatable #allKeys
			true
		)
		
		if queryBox ("DELETE ALL KEYS FROM SCENE ?") title:"DELETE ALL KEYS" then
			with redraw off
			(   
				trackbar.filter = #all
				local filtind = maxops.trackbar.registerFilter filterCallbackFunction undefined "." 1 active:on
				disableRefMsgs()
				local sel = getCurrentSelection()
				select objects
				maxops.trackbar.redraw forceRedraw:on
				maxops.trackbar.unregisterfilter filtind        
				select sel
				enableRefMsgs()
				--ok
			)
	),

	private
	
	/** Process transforms
	 */
	function executeCallback callback =
	(
		--format "\n"; print "KeyFrameManager_v.executeCallback()"
		--format "callback: %\n" callback
		--format "this.transforms: %\n" this.transforms
		--format "this.properties: %\n" this.properties
		
		for obj in this.objs do
		(
			--format "OBJ: %\n" obj.name
			
			ObjectControllerKeys = ObjectControllerKeys_v(obj)
			--format "ObjectControllerKeys: %\n" ObjectControllerKeys.keys_transforms.keys
			
			/*------------------------------------------------------------------------------
				TRANSFORMS KEYS
			--------------------------------------------------------------------------------*/
			--format "this.transforms: %\n" this.transforms
			--format "ObjectControllerKeys.keys_transforms.keys: %\n" ObjectControllerKeys.keys_transforms.keys
			
			for transform_type in ObjectControllerKeys.keys_transforms.keys where findItem this.transforms transform_type > 0 do
			(
				--format "TRANSFORM_TYPE: %\n" transform_type
			
				for ControllerKeys in ObjectControllerKeys.keys_transforms[transform_type] do
					this._processControllerKeys ControllerKeys callback
			)
			/*------------------------------------------------------------------------------
				MODS KEYS
			------------------------------------------------------------------------------*/
			if this.properties then
				for mod_index = 1 to ObjectControllerKeys.keys_mods.count
					where ( ControllersKeys = ObjectControllerKeys.keys_mods[mod_index]) != undefined  do
						for prop_name in ControllersKeys.keys do
							this._processControllerKeys ControllersKeys[prop_name] callback

		)
		
	),
	
	/** Process controller keys
	 */
	function _processControllerKeys ControllerKeys callback =
	(
		format "\n"; print "KeyFrameManager_v._processControllerKeys()"
		format "% CALLBACK: %\n" ControllerKeys.ctrl callback
		--format "ControllerKeys.keys: %\n" ControllerKeys.keys
		/** Copy key
		 */
		function _copyKey ctrl key_time =
		(
			format "\n"; print "KeyFrameManager_v._copyKey()"
			
			phase_length = this._getPhaseLenght()
			format "phase_length: %\n" phase_length
			new_time = ( key_time + phase_length ) as integer
			
			format "_copyKey % -> %\n" key_time new_time
			
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
		--format "properties: %\n" properties
		--format "time: %\n" time
		
		/* OBJECTS */ 
		this.objs = if objs == unsupplied then selection as Array else objs
		
		/* TIME */ 
		if time != unsupplied then 
			this.time = time
		
		/* TRANSFORMS AND MODS */ 
		if not ( transforms == unsupplied and properties == unsupplied ) then
		(
			/* TRANSFORMS */ 
			if transforms != unsupplied then 
				this.transforms = transforms
		
			/* MODS */ 
			if properties != unsupplied then 
				this.properties = properties
		)
		else /* SET TRANSFORMS AND MODS TO TRUE if both are undefined */ 
			this.transforms = this.properties = true
		
		--format "this.transforms: %\n" this.transforms

		/* get array #( #POSITION, #ROTATION, #SCALE ) */ 
		if classOf this.transforms == BooleanClass then
		(
			/* GET ALL OR NO TRANSFORM TRACKS */ 
			this.transforms = if this.transforms then transform_tracks_all else #()
			--format "this.TRANSFORMS: %\n" this.transforms
		)
		else if classOf this.transforms != Array then
			this.transforms = #( this.transforms )
		
		/* PROPERTY KEYS */ 
		if this.properties == undefined then
			this.properties = false
			
		
		/* SANITIZE ITEMS IN ARRAY */ 		
		this.transforms = for transform_type in this.transforms collect transform_type as name
	
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "KeyFrameManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
