clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TransformFlipper.ms" )	--"./../TransformFlipper.ms"





/** Create test object
 */
function createTestObject pos times wirecolor:( color (random 0 255) (random 0 255) (random 0 255)) =
(

	--obj = Box pos:pos wirecolor:( color (random 0 255) (random 0 255) (random 0 255))
	obj = Teapot	pos:pos wirecolor:wirecolor
	
	animate on
	(
		for i = 1 to times.count do
		(
			_time = times[i]
			
			at time _time
			
			obj.position.y += _time as integer
			--
			--case of
			--(
			--	--( mod _time 2 == 0 ): obj.position.x += _time
			--	( mod i 2 == 0 ): obj.rotation = (eulerAngles 0 0 180)
			--
			--
			--	default: obj.position.x += _time as integer
			--	--(
			--	--	obj.position.x += _time
			--	--	obj.rotation = (eulerAngles 0 45 0 )
			--	--)
			--)
		)
	)
	
	obj --return
)


/* Arrays of times (normally you’d collect these from controllers) */
--times_A = #( 0, 1 ,3 , 4, 5 )
times_A = #( 3,4,5 )

--times_B = #( 0, 2 ,3 ,4 )
--times_B = #( 20 )
times_B = #()


times_all = for i = amin ( times_A + times_B ) to amax ( times_A + times_B ) collect i

current_time = #( currentTime.frame as integer )

/* CREATE TEST OBJECTS */ 
--delete objects

--obj_A = createTestObject [ -50, 0, 0 ] times_A  wirecolor:red

--obj_B = createTestObject [  50, 0, 0 ] times_B wirecolor:green


/* GET TEST SELECTED OBJECTS */ 
obj_A = selection[1]

obj_B = selection[2]




--animationRange = Interval 0 ( amax ( times_A + times_B ) )
animationRange = Interval 0 10

/*  */
TransformFlipper = TransformFlipper_v()

--TransformFlipper.mirrorTrasformsAtTimes obj_A times_A obj_B times_B
--TransformFlipper.mirrorTrasformsAtTimes obj_A times_all obj_B times_all

			----with animate on
--TransformFlipper.swapLocalRotation obj_A obj_B currentTime.frame
TransformFlipper.flipIKControllers obj_A obj_B currentTime.frame #ROTATION
--TransformFlipper.flipIKControllers obj_A obj_B currentTime.frame #POSITION 
--TransformFlipper.mirrorTrasformsAtTimes (obj_A) (current_time) (obj_B) (current_time)

--TransformFlipper.mirrorTrasformsAtTimes selection[1] times_A selection[2] times_8
--TransformFlipper.mirrorTrasformsAtTimes selection[1] times_all selection[2] times_all

