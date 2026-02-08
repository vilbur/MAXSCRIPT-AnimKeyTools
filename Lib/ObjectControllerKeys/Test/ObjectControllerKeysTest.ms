clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys.ms" )	--"./../ObjectControllerKeys.ms"




/** Create test object
 */
function createTestObject times =
(
	delete objects

	--obj = Box pos:pos wirecolor:( color (random 0 255) (random 0 255) (random 0 255))
	obj = Teapot()	--pos:pos --wirecolor:wirecolor
	
	addModifier obj ( Bend() )
	addModifier obj ( Poly_Select() )
	
	animate on
	(
		for i = 1 to times.count do
		(
			_time = times[i]
			
			val = _time * 10
			
			at time _time
			(
				
				if val > 0 then
					obj.radius = val
				
				obj.position.y += val
	
				obj.rotation.z += val
				
				obj.modifiers[#bend].angle = val
			)
		)
	)
	
	
	animationRange = Interval 0 (amax times)
	
	obj --return
)

--obj = createTestObject #( 0, 1 ,3 , 5 )  

obj	= selection[1]

/* NEW INSTANCE */ 
ObjectControllerKeys = ObjectControllerKeys_v(obj)

/* PRINT KEYS */ 
ObjectControllerKeys.list()
