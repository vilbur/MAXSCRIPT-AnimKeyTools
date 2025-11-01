
/** Move obj cby
 */
function moveObjCbyAB direction:1 =
(
	--format "\n"; print ".moveObjCbyAB()"
	
	/* Execute move */
	if selection.count == 3 then
	(
	/*  Move node by active transform axis
		Distance is measured between two reference nodes
	*/
	--function moveByDistanceFromTwoRefs
		target_node = selection[3]
		ref_a = selection[1]
		ref_b = selection[2]
			
		/*  Helper
			Returns normalized active axis direction from node’s TM
		*/
		function getTMPropAxis node prop =
		(
			case toolmode.axisConstraints of
			(
				#x: node.transform.row1
				#y: node.transform.row2
				#z: node.transform.row3
				--#screen: (viewport.getTM()).row3
			)
			-- return
		)		
		
		
		local _distance = distance ref_a ref_b
		local dir_vec
	
		if toolMode.coordsys == #local then
		(
			dir_vec = in coordsys local ( normalize (getTMPropAxis target_node #pos))
		)
		else
		(
			dir_vec = in coordsys world ( normalize (getTMPropAxis target_node #pos))
		)
	
		move target_node (dir_vec * _distance * direction )
	
		
	)
)


--------------------------------------------------------
-- TEST CODE
--------------------------------------------------------

----/* Create 3 boxes for demonstration */
----box name:"Target"
----box name:"RefA" pos:(Point3 100 0 0)
----box name:"RefB" pos:(Point3 200 0 0)
----
----/* Select Target and set active axis (X/Y/Z/Screen) in UI */
----select $Target
----
----/* Execute move */
----moveByDistanceFromTwoRefs $Target $RefA $RefB