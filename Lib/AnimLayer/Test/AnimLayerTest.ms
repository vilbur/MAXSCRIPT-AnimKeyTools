filein( getFilenamePath(getSourceFileName()) + "/../AnimLayer.ms" )	--"./../AnimLayer.ms"

/*------------------------------------------------------------------------------
	PREPARE SCENE
--------------------------------------------------------------------------------*/

delete objects

_box	= Box()
_sphere	= Sphere()

box_layer = "Box Layer"
sphere_layer = "Sphere Layer"


sliderTime = 1

/*------------------------------------------------------------------------------
	TEST INSTANCE
--------------------------------------------------------------------------------*/

AnimLayer 	= AnimLayer_v()

AnimLayer.deleteAllLayers()




/*------------------------------------------------------------------------------
	ANIMATE BOX
--------------------------------------------------------------------------------*/

AnimLayer.addLayer _box box_layer

AnimLayer.setLayerActive box_layer

with animate on at time 2 _box.pos.x = 50


/*------------------------------------------------------------------------------
	ANIMATE SPHERE 
--------------------------------------------------------------------------------*/

AnimLayer.addLayer _sphere sphere_layer

AnimLayer.setLayerActive sphere_layer

AnimLayer.toggleLayer sphere_layer true

AnimLayer.activateBaseLayer()

with animate on at time 2 _sphere.pos.x = 100


/*------------------------------------------------------------------------------
	MANAGE LAYERS
--------------------------------------------------------------------------------*/

active_layer = AnimLayer.getActiveLayer _sphere
format "active_layer: %\n" active_layer

AnimLayer.activateBaseLayer()


active_layers = AnimLayer.getActiveLayers #(_box, _sphere)
format "active_layers: %\n" active_layers
