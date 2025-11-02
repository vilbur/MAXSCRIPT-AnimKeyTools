filein( getFilenamePath(getSourceFileName()) + "/../getPosOfObjCbyDistanceOfAB.ms" )	--"./../getPosOfObjCbyDistanceOfAB.ms"

/*------------------------------------------------------------------------------
	TEST CODE
--------------------------------------------------------------------------------*/

delete objects   

/* create nodes */
box name:"A" pos:(Point3 0 0 0)
box name:"B" pos:(Point3 0 100 0)

sphere name:"C" pos:(Point3 100 0 0) -- rotate C if you want to test different axis dirs

/* GET DISTANCE ON Y AXIS */

format "distance A->B on C.Y: %\n" ( getPosOfObjCbyDistanceOfAB $A $B $C axis:#Y )

/* GET AXIS BY ACTIVE AXIS IN MAIN TOOL BAR */ 

--format "distance A->B on C.Y: %\n" ( getPosOfObjCbyDistanceOfAB $A $B $C  )
