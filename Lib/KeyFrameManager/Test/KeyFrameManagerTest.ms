clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../KeyFrameManager.ms" )	--"./../KeyFrameManager.ms"

/** Create test object
 */
function createTestObject =
(
	--format "\n"; print ".createTestObject()"
	
	delete objects
	
	obj = Teapot isSelected:true radius:20 wirecolor:red
	
	
    animate on
    (
        --at time 1 obj.position  = [ 10, 0, 0 ]
        at time 5 obj.position = [ 100, 0, 0 ]
        at time 10 obj.position = [ 200, 0, 0 ]
        at time 15 obj.position = [ 300, 0, 0 ]
		
		
		at time 20 Rotate obj ( AngleAxis -180 [0,0,1])

		at time 25  obj.radius = 100
    )
	

	addModifier obj ( Bend())
	
	 /* Animate Angle parameter */ 
	animate on
	(
		at time 0  obj.modifiers[#bend].angle = 0
		at time 10 obj.modifiers[#bend].angle = 45
		at time 20 obj.modifiers[#bend].angle = -30 
	)
	
	obj --return
)

/** Clone test object
 */
function cloneTestObject =
(
	--format "\n"; print ".cloneTestObject()"
	maxOps.CloneNodes #(obj) offset:[0,100,0] newNodes:&nnl
	
	obj_clone = nnl[1]
	
	obj_clone.wirecolor = green
	
	obj_clone --return
)

/*------------------------------------------------------------------------------
	SETUP SCENE
--------------------------------------------------------------------------------*/
/* OBJECTS  */ 
delete objects

obj = createTestObject()

obj_clone = cloneTestObject()

/* ANIMATION */ 
animationRange = Interval 0 20

sliderTime = 10
sliderTime = 5


/*------------------------------------------------------------------------------
	NEW ISNTANCE
--------------------------------------------------------------------------------*/

KeyFrameManager 	= KeyFrameManager_v() --time:#RIGHT -- DELETE CURRENT TIME IF time == undefined 


/*------------------------------------------------------------------------------
	OPTIONS
--------------------------------------------------------------------------------*/

/* DELETE ONLY SELECTED KEYS */ 
--KeyFrameManager.only_selected = true

--KeyFrameManager.time = #RIGHT
KeyFrameManager.time = #CURRENT

/*------------------------------------------------------------------------------
	CREATE KEYS
--------------------------------------------------------------------------------*/
--KeyFrameManager.createKeys()

--KeyFrameManager.insertKeys()



/*------------------------------------------------------------------------------
	COPY KEYS
----------------------------------------------------------------------------------*/
--sliderTime = 0
--KeyFrameManager.copyKeys time:#CURRENT
--
--/* Copy keys in range 1-10 to 11-20 */ 
--KeyFrameManager.copyKeys time:[ 1, 10 ] transforms:true properties:false -- default increment is length ofrange + 1
--
--/* COPY POSITION KEYS ABOUT 30 FRAMES FORWARD */ 
--KeyFrameManager.copyKeys time:[ 0, 10 ] increment:30 transforms:#POSITION
--
--

/*------------------------------------------------------------------------------
	MIRROR
--------------------------------------------------------------------------------*/

--sliderTime = start_frame = 3


--KeyFrameManager.mirrorKeys time:[ start_frame, start_frame + 2 ]
--KeyFrameManager.mirrorKeys time:[ start_frame, start_frame  ]


/*------------------------------------------------------------------------------
	SELECT OBJECTS BY KEYS
------------------------------------------------------------------------------*/
clearSelection()

select (KeyFrameManager.getObjectsWithKeys())



/*------------------------------------------------------------------------------
	DELETE KEYS
--------------------------------------------------------------------------------*/

--select obj_clone


/* ALL KEYS OF SELECTION */ 
--KeyFrameManager.removeKeys()
--
--/* TRIM RIGHT */ 
--KeyFrameManager.removeKeys time:#RIGHT
--
--
--/* ALL KEYS FROM OBJECTS IN TIME RANGE */ 
--KeyFrameManager.removeKeys objs: selection[1] time:[ 10, 50 ]
--


/*------------------------------------------------------------------------------
	DELETE KEYS - TRANSFORMS
--------------------------------------------------------------------------------*/

--/* TRANSFORMS each */
--KeyFrameManager.removeKeys transforms:#POSITION
--KeyFrameManager.removeKeys transforms:#ROTATION
--KeyFrameManager.removeKeys transforms:#SCALE
--		
--/* TRANSFORMS all */
--KeyFrameManager.removeKeys transforms:true time:undefined
--

/*------------------------------------------------------------------------------
	DELETE KEYS - PROPERTIES
--------------------------------------------------------------------------------*/

--/* BASEOBJECT */
--KeyFrameManager.removeKeys properties:#BASEOBJECT
 
/* MODIFIERS */
--KeyFrameManager.removeKeys properties:#MODIFIERS

--/* PROPERTIES all modifiers and baseobject */
--KeyFrameManager.removeKeys properties:true

