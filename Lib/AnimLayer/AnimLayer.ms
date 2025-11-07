/** Anim layer
 */
struct AnimLayer_v
(
	/* construct */
	/* required */
	
	/* properties */
	anim_layers, -- Dictionary #STRING -- KEY:"Layer name VALUE:layer index
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Create anim layer
	 */
	function enableLayers objs =
	(
		--format "\n"; print "AnimLayer_v.createAnimLayer()"
		AnimLayerManager.enableLayers objs pos:true rot:true scale:false
	),
	
	/** Add layer
	 */
	function addLayer objs layer_name =
	(
		--format "\n"; print "AnimLayer_v.addLayer()"
		if classOf objs != Array then #( objs )
		
		--format "TEST: %\n" ( AnimLayerManager.getNodesLayers objs )

		for obj in objs where ( AnimLayerManager.getNodesLayers obj ).count == 0 do 
		--if ( AnimLayerManager.getNodesLayers objs ).count == 0 then
			this.enableLayers objs
		
		AnimLayerManager.addLayer layer_name objs true
		
		this._setAnimLayers()
	),
	
	/** Has layer
	 */
	function hasLayer objs index_or_name =
	(
		--format "\n"; print "AnimLayer_v.hasLayer()"
		( index = this._getLayerIndex index_or_name ) != undefined and findItem ( this.getLayers objs ) index > 0
	),
	
	/** Set layer active
	 */
	function setLayerActive index_or_name =
	(
		--format "\n"; print "AnimLayer_v.setLayerActive()"
		
		if ( index = this._getLayerIndex index_or_name ) != undefined then 
			AnimLayerManager.setLayerActive index
	),
	
	/** Actiate base layer
	 */
	function activateBaseLayer =
	(
		--format "\n"; print "AnimLayer_v.activateBaseLayer()"
		this.setLayerActive "Base Layer"
	),
	
	/** Get layer
	 */
	function getLayers objs =
	(
		--format "\n"; print "AnimLayer_v.getLayer()"
		
		AnimLayerManager.getNodesLayers objs
	),
	
	/** Get active layers nodes
	 */
	function getActiveLayer obj =
	(
		--format "\n"; print "AnimLayer_v.getActiveLayersNodes()"
		if (active_layers_of_object = AnimLayerManager.getActiveLayersNodes obj).count > 0 then
			AnimLayerManager.getLayerName active_layers_of_object[1] --return
	),
	
	/** Get active layers nodes
	 */
	function getActiveLayers objs =
	(
		--format "\n"; print "AnimLayer_v.getActiveLayersNodes()"
		
		if (active_layers_of_objects = AnimLayerManager.getActiveLayersNodes objs).count > 0 then
			--for i = 1 to active_layers_of_objects.count do
			for i in active_layers_of_objects collect 
				AnimLayerManager.getLayerName i --return
	),
	
	/** Delete all Layers
	 */
	function deleteAllLayers =
	(
		--format "\n"; print "AnimLayer_v.deleteAllLayers()"
		if ( layer_count = AnimLayerManager.getLayerCount()) > 1 then
			for i = AnimLayerManager.getLayerCount() to 2 by -1 do
				AnimLayerManager.deleteLayer i
			--format "layer name: %\n" (AnimLayerManager.getLayerName i)
		this._setAnimLayers()
	),
	
	/** Toggle layer
	 */
	function toggleLayer index_or_name state =
	(
		--format "\n"; print "AnimLayer_v.toggleLayer()"
		if ( index = this._getLayerIndex index_or_name ) != undefined then 
			AnimLayerManager.setLayerMute index (not state)
	),
	
	/** Get layer index
	 */
	function _getLayerIndex index_or_name =
	(
		--format "\n"; print "AnimLayer_v._getLayerIndex()"
		if classOf index_or_name == string then anim_layers[index_or_name] else index_or_name --return
	),
	
	--/** Disable walk anim layer
	--  * Steps are animated on same position
	-- */
	--function toggleWalkAnimLayer state =
	--(
	--	format "\n"; print "RigWrapper_v.toggleWalkAnimLayer()"
	--	format "state: %\n" state
	--	
	--	current_state = true
	--	
	--	--master_walk = execute ("$'"+rig_name+"_Setup_Ctrl_MasterWalk_G'") --return
	--	
	--	master_walk = (this.getRigControls "MasterWalk")[1]
	--
	--	if ( walk_anim_layer = (AnimLayerManager.getNodesLayers master_walk)[1] ) != undefined then
	--	(
	--		format "walk_anim_layer: %\n" walk_anim_layer
	--		anim_layer_name = AnimLayerManager.getLayerName walk_anim_layer
	--				master_walk = (this.getRigControls "MasterWalk")[1]
	--
	--		current_state = AnimLayerManager.getLayerMute  walk_anim_layer
	--		
	--		format "anim_layer_name: %\n" anim_layer_name
	--		
	--		/* MUTE anim layer */ 
	--		AnimLayerManager.setLayerMute walk_anim_layer (not state)
	--	)
	--	/* ADD ANIM LAYER */ 
	--	else
	--	(
	--		AnimLayerManager.enableLayers #( master_walk ) pos:true rot:true
	--		
	--		/* DISABLE JSUT CREATED LAYER */ 
	--		if state == false then
	--			this.toggleWalkAnimLayer false
	--	)
	--	
	--	current_state --return
	--),
	
	private
	
	/** Set anim layers
	 */
	function _setAnimLayers =
	(
		--format "\n"; print "AnimLayer_v._setAnimLayers()"
		anim_layers	= Dictionary #STRING -- KEY:"Layer name VALUE:layer index

		--if ( layer_count = AnimLayerManager.getLayerCount()) > 1 then
			--for i = AnimLayerManager.getLayerCount() to 2 by -1 do
			for i = AnimLayerManager.getLayerCount() to 1 by -1 do
				anim_layers[ AnimLayerManager.getLayerName i ] = i
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "AnimLayer.onCreate()"
		this._setAnimLayers()
	)

)
