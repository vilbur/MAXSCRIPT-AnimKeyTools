filein( getFilenamePath(getSourceFileName()) + "/ControllerKeys/ControllerKeys.ms" )	--"./ControllerKeys/ControllerKeys.ms"

/** Object ctrl keys
 */
struct ObjectControllerKeys_v
(
	/* construct */
	obj,
	
	/* required */
	
	/* keys_mods */
	keys_transforms	= Dictionary #NAME, -- key: #POSITION|#ROTATION|#SCALE value: #( ControllerKeys_v )
	
	keys_mods = Dictionary #INTEGER, -- key: index_of_modifier value: #( ControllerKeys_v )
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Serach for keys in controllers
	 */
	function serachForKeysInControllers =
	(
		--format "\n"; print "ObjectControllerKeys_v.serachForKeysInControllers()"
		this._setTransformKeys()
		
		this.setKeytsOfModsProperties()
	),
	
	/** Fiter keys
	 */
	function getKeys which time_interval =
	(
		--format "\n"; print "ObjectControllerKeys_v.getKeys()"
		--format "which: %\n" which
		--format "time_interval: %\n" time_interval
		
		keys_filtered	= Dictionary #NAME

		
		if which != #PROPERTIES then
		(
			keys_flat = #()
			
			transform_tracks = if which == #TRANSFORMS then keys_transforms.keys else #( which )

			for transform_track in transform_tracks where keys_transforms[transform_track] != undefined do
				for ControllerKeys in keys_transforms[transform_track] do
					keys_flat +=  if time_interval != undefined then ControllerKeys.filterKeys (time_interval) else ControllerKeys.keys
			
		)
		else
		(
			FORMAT "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
			print "ObjectControllerKeys_v.getKeys()"
			
			FORMAT "UNSUPORTED VALUE OF parameter which: %\n" which
		)
		
		sort( makeUniqueArray keys_flat ) --return
	),
	
	/** Key exists
	 */
	function keyExists transfrom_prop key_time =
	(
		--format "\n"; print "ObjectControllerKeys_v.keyExists()"
		
		--format "key_time: %\n" key_time
		--format "transfrom_prop: %\n" transfrom_prop
		--format "keys_transforms[transfrom_prop]: %\n" keys_transforms[transfrom_prop]
		--format "INDEX: %\n" ( findItem keys_transforms[transfrom_prop] key_time )
		--
		key_found = false
		
		if keys_transforms[transfrom_prop] != undefined then 
			for sub_ctrl in keys_transforms[transfrom_prop] while key_found == false do 
				key_found = findItem sub_ctrl.keys key_time > 0
		
		key_found --return
	),
	
	/** Delete keys
	 */
	function removeKeys which keys =
	(
		--format "\n"; print "ObjectControllerKeys_v.removeKeys()"
		--format "keys: %\n" keys
		
		if classOf keys != Array then
			keys = #( keys )
		
		keys = for key in keys collect key as integer
		
		if which != #PROPERTIES then
		(
			keys_flat = #()
			
			transform_tracks = if which == #TRANSFORMS then keys_transforms.keys else #( which )
			--format "transform_tracks: %\n" transform_tracks
			for transform_track in transform_tracks where keys_transforms[transform_track] != undefined do
				for ControllerKeys in keys_transforms[transform_track] do
				(
					--format "ControllerKeys.keys: %\n" ControllerKeys.keys
						--format "ControllerKeys.ctrl: %\n" ControllerKeys.ctrl
					
					for key in ControllerKeys.keys where findItem keys key > 0 do
						deleteKey ControllerKeys.ctrl (getKeyIndex ControllerKeys.ctrl key)
					--for key in ControllerKeys.keys do
					--(
					--	format "key: %\n" key
					--	format "INDEX: %\n" (findItem keys key > 0)
					----format "INDEX: %\n" (getKeyIndex ControllerKeys.ctrl key)
					--)
					
				)

		)
		else
		(
			--format "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
			print "ObjectControllerKeys_v.getKeys()"
			
			--format "UNSUPORTED VALUE OF parameter which: %\n" which
		)
		
		
	),
	
	/** Has any keys
	 */
	function hasAnyKeys =
	(
		--format "\n"; print "ObjectControllerKeys_v.hasAnyKeys()"

		keys_transforms.count > 0 or keys_mods.count > 0
	),

	private

	/** Set transform keys
	 */
	function _setTransformKeys =
	(
		--format "\n"; print "ObjectControllerKeys_v._setTransformKeys()"
		
		for transform_track in #( #POSITION, #ROTATION, #SCALE ) do 
		--for transform_track in #( #POSITION ) do -- DEV
		(
			--format "\n*********************************\n"
			--format "transform_track: %\n" transform_track

			ctrl = case transform_track of
			(
				#POSITION: obj.position.controller 
				#ROTATION: obj.rotation.controller 
				#SCALE:    obj.scale.controller 
			)

			/* GET KEYS FOR EAH CONTROLLER */ 
			if ( controllers_keys = this._searchForControllerKeys ctrl).count > 0 then
				keys_transforms[transform_track] = controllers_keys

		)
	),
	
	/** Set mods keys_mods
	 */
	function setKeytsOfModsProperties =
	(
		--format "\n"; print "ObjectControllerKeys_v.setKeytsOfModsProperties()"
		
		mods_all = obj[4] --  Modified_Object
		
		mods = for m = 1 to mods_all.numSubs where (_mod = getSubAnim mods_all m) != undefined collect _mod

		/*  */
		for m = 1 to mods.count
			where ( keys_of_mod = this._getKeysFromMod mods[m] ) != undefined do
			keys_mods[m] = keys_of_mod
			
			--if ( keys = this._getKeysFromMod mods[m]).keys.count > 0 then
				--keys_mods[m] = keys
	),
	
	
	/** Remove keys from mod
	 */
	function _getKeysFromMod _mod =
	(
		--format "\n\n*********************************\n"
		--format "\n"; print "KeyFrameManager_v._getKeysFromMod()"
		--format "_mod: %\n" _mod
		
		
		/** Delete keys from keys_mods
		 */
		function _getKeysFromProperties sub_anim &mod_keys =
		(
			--format "\n\n\n"; print "KeyFrameManager_v._getKeysFromProperties()"
			--format "PROP_NAMES: %\n" ( getPropNames sub_anim )
			/* FOR EACH PROPERTY OF MOD */ 
			for i = 1 to ( prop_names = getPropNames sub_anim ).count \
				/* IF PROPERTY HAS CONTROLLER */ 
				where (ctrl = getPropertyController sub_anim prop_names[i]) != undefined do
				(
					prop_name = prop_names[i]
					/* GET KEYS FROM CONTROLLER */ 
					controllers_keys = this._searchForControllerKeys ctrl

					if controllers_keys.count > 0 then
						mod_keys[prop_name] = controllers_keys[1]
				)
				
			mod_keys --return
		)
		
		mod_keys	= Dictionary #NAME -- KEY:#prop_name VALUE:ControllerKey_v
		
		/*------------------------------------------------------------------------------
			GET KEYS OF PROPERTIES
		--------------------------------------------------------------------------------*/
		_getKeysFromProperties (_mod)(mod_keys)
		
		/*------------------------------------------------------------------------------
			GET KEYS OF CUSTOM ATTRIBUTES
		--------------------------------------------------------------------------------*/
		try( -- prevent error with deleted scene node
			
			for cust_attributes in _mod.custAttributes do
				_getKeysFromProperties (cust_attributes)(mod_keys)
			
		)catch()
		
		--format "MOD_KEYS: %\n" mod_keys
		
		if mod_keys.count > 0 then
			mod_keys --return
	),
	
	
	/** Delete keys from ctrl
	 */
	function _searchForControllerKeys ctrl controllers_keys:#() =
	(
		--format "\n"; print "KeyFrameManager_v._searchForControllerKeys()"
		--format "ctrl: %\n" ctrl
		
		num_keys = numKeys ctrl
		
		/*------------------------------------------------------------------------------
			SEARCH FOR KEYS IN SUBANIMS
		--------------------------------------------------------------------------------*/
		--if num_keys== -1 then
		if ctrl.numSubs > 0 then
		(
			/* LOOP SUBANIMS */ 
			for i = 1  to ctrl.numSubs do
				/* GET SUBANIM */ 
				if ( sub_anim_ctrl = getSubAnim ctrl i) != undefined then
					/* GET CONTROLLER OF SUBANIM */ 
					if (sub_ctrl = getPropertyController ctrl sub_anim_ctrl.name) != undefined then
					(
						/* DELETE KEYS OF SUBANIM */
						controllers_keys = this._searchForControllerKeys sub_ctrl controllers_keys:controllers_keys
						
					)
		)
		/*------------------------------------------------------------------------------
			GET KEYS FROM CONTROLLER
		--------------------------------------------------------------------------------*/
		else
		if num_keys > 0 then
		(
			keys = this._getKeysFromController ctrl num_keys
			
			if keys.count > 0 then
				append controllers_keys ( ControllerKeys_v ctrl keys  )
		)
		
		controllers_keys --return
	),
	
	/** Get keys from ctrl
	 */
	function _getKeysFromController ctrl num_keys =
	(
		--format "\n"; print "ObjectControllerKeys_v._getKeysFromController()"
		for k = 1 to num_keys collect (getKeyTime ctrl k).frame as integer
		--keys =  for k = 1 to num_keys collect (getKeyTime ctrl k).frame as integer
		--format "KEYS: %\n" keys
		--ControllerKeys_v ctrl keys --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ObjectControllerKeys.onCreate()"
		this.serachForKeysInControllers()
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct keys_mods necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
