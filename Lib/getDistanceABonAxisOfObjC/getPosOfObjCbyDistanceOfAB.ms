clearListener(); print("Cleared in:\n"+getSourceFileName())

/*  Get distance of two reference nodes
    
    distance of objects A and B in y axis direction vector of object c
	
*/
function getPosOfObjCbyDistanceOfAB ref_a ref_b target_node axis:undefined direction:1 =
(
	
    /* Returns axis row of node TM */
    function getTMPropAxis node axis =
    (
        case axis of
        (
            #x: node.transform.row1
            #y: node.transform.row2
            #z: node.transform.row3
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
	
	
	prop_axis = ( normalize (getTMPropAxis target_node axis) )
	
    dir_on_axis = if toolMode.coordsys == #local then
       in coordsys local prop_axis
    else
       in coordsys world prop_axis

    /* project AB vector onto target’s Y axis */
    local _distance = dot vec_ab dir_on_axis

	--move target_node (dir_on_axis * _distance * direction )

	(dir_on_axis * _distance * direction ) --return
)
