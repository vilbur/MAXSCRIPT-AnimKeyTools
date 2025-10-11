clearListener(); print("Cleared in:\n"+getSourceFileName())

/** Create test object
 */
function createTestObject pos times =
(
	--format "\n"; print ".createTestObject()"
	delete objects
	
	obj = Box pos:pos wirecolor:( color (random 0 255) (random 0 255) (random 0 255))
	
	animate on
	(
		for t = 1 to times.count do
		(
			
			_time = times[t]
			
			at time _time 
			case of
			(
				--( mod _time 2 == 0 ): obj.position.x += _time
				( mod t 2 == 0 ): obj.rotation = ( EulerAngles 0 0 180)


				default: obj.position.y += _time as integer
				--(
				--	obj.position.x += _time
				--	obj.rotation = (eulerAngles 0 45 0 )
				--)
			)
		)
	)
	
	obj --return
)




/** Delete keys from controller
 */
function _searchForControllerKeys ctrl level =
(
	
	prefix = ""
	
	for i = 0 to level do prefix += "    "
	
	
	format "\n"
	--format "\n======================================================\n"
	--format "\n"; print "KeyFrameManager_v._searchForControllerKeys()"
	format "level: %\n" level
	format "%ctrl: %\n" prefix ctrl
	format "%isController: %\n" prefix (isController ctrl)
	format "%CLASSOF: %\n" prefix ( classOf ctrl )
	format "%NUMSUBS: %\n" prefix ctrl.numSubs
	format "%NUMKEYS: %\n" prefix (numKeys CTRL)
	
	
	level += 1

	--if ( num_keys = numKeys ctrl ) > -1 then
		--format "getKeyIndex ctrl 0: %\n" (getKeyIndex ctrl 0 )
	
	
	/*------------------------------------------------------------------------------
		SEARCH FOR KEYS IN SUBANIMS
	--------------------------------------------------------------------------------*/
	if ctrl.numSubs > 0 then
	(
		for i = 1 to ctrl.numSubs do
		(
			/* GET SUBANIM */ 
			if (sub_anim_ctrl = getSubAnim ctrl i) != undefined then
			(
				format "%sub_anim_ctrl: %\n" prefix sub_anim_ctrl
				--format "sub_anim_ctrl.name: %\n" sub_anim_ctrl.name
				/* GET CONTROLLER OF SUBANIM */ 
				if (sub_ctrl = getPropertyController ctrl sub_anim_ctrl.name) != undefined then
				(
					format "%sub_ctrl: %\n" prefix sub_ctrl
					/* DELETE KEYS OF SUBANIM */ 
					_searchForControllerKeys sub_ctrl level
				)
			)
		)
	)
	
)

times_A = #( 0, 10 ,30 , 40, 50 )


--obj = createTestObject [ -50, 0, 50 ] times_A

obj	= selection[1]

key_index = _searchForControllerKeys obj.position.controller 0
						
--format "key_index: %\n" key_index
