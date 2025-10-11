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

/*  */ 
ObjectControllerKeys = ObjectControllerKeys_v(obj)


format "\nTRANSFORM KEYS:\n"

for transform_name in ObjectControllerKeys.keys_transforms.keys do
(
	format "\ntransform_name: %\n" transform_name
	for ControllerKeys in ObjectControllerKeys.keys_transforms[transform_name] do
		format "%: %\n" ControllerKeys.ctrl ControllerKeys.keys
)



format "\nPROPERTY KEYS:\n"
for mod_index = 1 to ObjectControllerKeys.keys_mods.count do
(
	format "\nmod_index: %\n" mod_index
	keys_of_mod = ObjectControllerKeys.keys_mods[mod_index]
	
	for prop_name in keys_of_mod.keys do
		format "%: 	%\n" prop_name keys_of_mod[prop_name]
)
		
		

--format "ObjectControllerKeys.keys_transforms: %\n" ObjectControllerKeys.keys_transforms
--format "ObjectControllerKeys.properties: %\n" ObjectControllerKeys.properties


