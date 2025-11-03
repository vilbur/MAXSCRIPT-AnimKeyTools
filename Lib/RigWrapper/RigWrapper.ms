filein( getFilenamePath(getSourceFileName()) + "/../TransformFlipper/TransformFlipper.ms" )	--"./../TransformFlipper/TransformFlipper.ms"
filein( getFilenamePath(getSourceFileName()) + "/LeftRightControls/LeftRightControls.ms" )	--"./LeftRightControls/LeftRightControls.ms"
/**
 */
struct RigWrapper_v
(
	/* construct */
	rig_name, --string rig_name E.G.: "Boy" | $Boy_Setup_Ctrl_MasterControl_G

	
	/* properties */
	master_control,
	
	rig_controls,
	
	key_times, -- #( int ) -- times to flip
	
	rx = ( dotNetClass "System.Text.RegularExpressions.RegEx" ),
	
	TransformFlipper = TransformFlipper_v(),

	control_name_pattern = "(.*_Setup_Ctrl_([^_]+_)).*",
	
	/* private */ 
	--walk_anim_layer,
	
	/** Load rig
	 */
	function loadRig =
	(
		format "\n"; print "RigWrapper_v.loadRig()"
		
		master_control = this._getMasterControlOfRig(rig_name)
		--format "master_control: %\n" master_control
		processed_objects = #()

		this.rig_controls	= Dictionary #STRING -- KEY: VALUE:
		--format "this.rig_controls: %\n" this.rig_controls
		
		rig_name = (filterString master_control.name "_")[1]	
		
		rig_objs = execute ("$'"+ rig_name +"_Setup_Ctrl_*'") as Array
		
		for rig_obj in rig_objs where findItem processed_objects rig_obj == 0 do
		(
			--format "rig_obj: %\n" rig_obj
			/* ANALIZE OBJ NAME */ 
			split_name = this.splitName rig_obj.name
			basename   = split_name[2]
			side       = split_name[3]
			
			
			/* GET OBJ NMAE PATTERN */ 
			full_basename = rig_name +"_Setup_Ctrl_"+basename -- E.G.: "boy_Setup_Ctrl_IKFoot"

			
			/* GET OBJECTS WITH SAME PATTERN OF NAME  */ 
			same_name_objs = execute ("$'"+ full_basename +"_*'") as Array
			
			
			/* ADD CONTROL PAIR TO DICTIONARY */ 
			if same_name_objs.count == 2 and (side == "L" or side == "R") then
				rig_controls[full_basename] = (LeftRightControls_v()).addObjects(same_name_objs)(full_basename)
			
			else
				format "%: %\n" same_name_objs.count same_name_objs
			
			/* AVOID PROCESSING OF SAME OBJECTS AGAIN  */ 
			processed_objects += same_name_objs
		)
		
		
		--format "rig_objs.count: %\n" rig_objs.count
		--format "rig_controls: %\n" rig_controls


		rig_controls --return
	),
	
	/** Mirror sifted phases
	  
		GET TRANSFROMS ON KEY TIMES OF BOTH OBJECTS
		FLIP ORINATATION OF TRANSFROMS
		SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT	  
		
		@param dictionary rig_controls list of controls E.G.: rig_controls["boy_Setup_Ctrl_IKFoot"]["L|R"] = #()
		
		
	 */
	function mirrorPhase phase increment:undefined =
	(
		--format "\n"; print "PhaseCreator_v.mirrorPhases()"
		--format "PHASE: %\n" phase
		all_ctrls = #()
		
		KeyFrameManager = KeyFrameManager_v time:phase
		
		if increment == undefined or increment as Number == undefined then
			increment = phase[2] - phase[1] + 1
		
		--format "INCREMENT: %\n" increment
		
		this.toggleWalkAnimLayer(false)
		
		for control_name in rig_controls.keys do
			rig_controls[control_name].switchKeysOnTimes phase increment:increment
		
		this.moveHipWithFeet()
		
		this.toggleWalkAnimLayer(true)
		
		/* SET TIME TO FIRST AFTER PHASE */ 
		sliderTime += increment
	),
		/** Move hip with feet
	 */
	function moveHipWithFeet =
	(
		format "\n"; print "RigWrapper_v.moveHipWithFeet()"
		
		for control_name in rig_controls.keys do format "control_name: %\n" control_name

		format "\n"
		feet = this.getRigControls "IKFoot_"
		format "feet: %\n" feet
		format "feet[1]: %\n" feet[1]
		format "feet[2]: %\n" feet[2]
		format "feet[1]: %\n" (classOf feet[1])
		format "feet.count: %\n" feet.count
		
		master_upper_body = (this.getRigControls "MasterUpperBody")[1]
		format "master_upper_body: %\n" master_upper_body
		
		hip_pos = this.getPosOfObjCbyDistanceOfAB feet[1] feet[2] master_upper_body axis:#Y direction:-1
		
		format "HIP_POS: %\n" hip_pos
		--format "ikfoot: %\n" ikfoot
	),
	
	/** Load rig from scene
	  
	  @params string rig_name E.G.: Boy > Boy_Setup_Ctrl_MasterControl_G
	 */
	function _getMasterControlOfRig rig_name =
	(
		--format "\n"; print "RigWrapper_v._getMasterControlOfRig()"
		--format "rig_name: %\n" rig_name
		--format "TEST: %\n" (execute ("$'"+rig_name+"_Setup_Ctrl_MasterControl_G'"))

		--(execute ("$'"+rig_name+"_Setup_Ctrl_MasterControl_G'") as Array )[1] --return
		execute ("$'"+rig_name+"_Setup_Ctrl_MasterControl_G'") --return
	),

	/** Get rig control
	 */
	function getRigControls control_name =
	(
		--format "\n"; print "RigWrapper_v.getRigControls()"
		if ( object_set = execute ("$'"+rig_name+"_Setup_Ctrl_"+ control_name +"*'") ) != undefined then
			object_set as Array --return
	),

	/** Split name
	 */
	function splitName obj_name part: =
	(
		--format "\n"; print "RigWrapper_v.splitName()"
		matches = rx.matches obj_name "(.*)_Setup_Ctrl_([^_]+)_([^_]+).*" -- ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase 

		/* RESULT: #(#("boy_Setup_Ctrl_IKFoot_R_O_1LRV", "IKFoot", "L")) */ 
		result	= ( for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value ))[1] --return
		--format "result: %\n" result
		deleteItem result 1
		
		case part of
		(
			#RIG:  result[1] 
			#NAME: result[2] 
			#SIDE: result[3]
			
			default: result
		)
	),
	
	/** Search for rigs in scene
	 */
	function searchForRigsInScene =
	(
		--format "\n"; print "RigWrapper_v.searchForRigsInScene()"

		execute ("$'*_Setup_Ctrl_MasterControl_G'") as Array --return
	),
	
	/** Search for rigs in scene
	 */
	function getNamesOfRigsInScene =
	(
		--format "\n"; print "RigWrapper_v.searchForRigsInScene()"
		
		rig_masters = execute ("$'*_Setup_Ctrl_MasterControl_G'") as Array
		
		
		rig_names = for rig_master in rig_masters collect (filterString rig_master.name "_")[1]
		
		--format "rig_masters: %\n" rig_masters
		
		--#( "Boy" ) --return
		rig_names --return
	),
	
	/** Disable walk anim layer
	  * Steps are animated on same position
	 */
	function toggleWalkAnimLayer state =
	(
		format "\n"; print "RigWrapper_v.toggleWalkAnimLayer()"
		format "state: %\n" state
		
		master_walk = execute ("$'"+rig_name+"_Setup_Ctrl_MasterWalk_G'") --return
		
		if ( walk_anim_layer = (AnimLayerManager.getNodesLayers obj)[1] ) != undefined then
		(
			anim_layer_name = AnimLayerManager.getLayerName walk_anim_layer
			format "anim_layer_name: %\n" anim_layer_name
			
			/* MUTE anim layer */ 
			AnimLayerManager.setLayerMute walk_anim_layer (not state)
		)
		/* ADD ANIM LAYER */ 
		else
		(
			AnimLayerManager.enableLayers #( master_walk ) pos:true rot:true
			
			/* DISABLE JSUT CREATED LAYER */ 
			if state == false then
				this.toggleWalkAnimLayer false
		)
	),


	private
	/*  Get distance of two reference nodes
		
		distance of objects A and B in y axis direction vector of object c
		
	*/
	function getPosOfObjCbyDistanceOfAB ref_a ref_b target_node axis:undefined direction:1 =
	(
		format "\n"; print "RigWrapper_v.getPosOfObjCbyDistanceOfAB()"

		/* Returns axis row of node TM */
		function getTMPropAxis _node axis =
		(
			case axis of
			(
				#x: _node.transform.row1
				#y: _node.transform.row2
				#z: _node.transform.row3
			)
			-- return
		)
	
		/* vector from A to B */
		local vec_ab = (ref_b.position - ref_a.position)
	
		/* target’s Y direction (local/world depending on coord sys) */
		local dir_on_axis
		
		/* GET AXIS BY ACTIVE AXIS IN MAIN TOOL BAR */ 
		if axis == undefined then
			axis = toolmode.axisConstraints
		--format "classOf target_node: %\n" ( classOf target_node )
		--format "target_node.transform: %\n" target_node.transform
		prop_axis = ( normalize (getTMPropAxis target_node axis) )
		
		dir_on_axis = if toolMode.coordsys == #local then
		   in coordsys local prop_axis
		else
		   in coordsys world prop_axis
		
		/* project AB vector onto target’s Y axis */
		local _distance = dot vec_ab dir_on_axis
		
		--move target_node (dir_on_axis * _distance * direction )
		
		(dir_on_axis * _distance * direction ) --return
	),
	
	
	/**
	 */
	on create do
	(
		--format "\n"; print "RigWrapper.onCreate()"
		if rig_name != undefined then 
			this.loadRig()
	)
)
