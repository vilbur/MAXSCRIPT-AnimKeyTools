clearListener(); print("Cleared in:\n"+getSourceFileName())


/* 
Function to create rollout with checkbutton that uses bulb icon.
Bulb will change image when toggled.
*/
--
--function showBulbButtonRollout =
--(
--	try(destroyDialog ROL_BulbButton)catch()
--	
--	rollout ROL_BulbButton "Bulb Button"
--	(
--		checkbutton btn_bulb " " width:32 height:32 images:"Light Toggle"
--		
--		local icon_on  = getDir #ui + "\\Icons\\LightBulb_on.bmp"
--		local icon_off = getDir #ui + "\\Icons\\LightBulb_off.bmp"
--		format "icon_on: %\n" icon_on
--		--on ROL_BulbButton open do
--		--(
--		--	if doesFileExist icon_off then btn_bulb.images = #(icon_off,icon_on,icon_on,icon_off)
--		--)
--		--
--		--on btn_bulb changed state do
--		--(
--		--	if state then
--		--		format "Bulb ON\n"
--		--	else
--		--		format "Bulb OFF\n"
--		--)
--	)
--	
--	createDialog ROL_BulbButton width:60 height:60
--)
---- return
--
--
--/* -------------------
--	Test code
--------------------- */
--showBulbButtonRollout()
--



obj	= selection[1]

--AnimLayerManager.disableLayerNodes obj


if ( obj_anim_layer = (AnimLayerManager.getNodesLayers obj)[1] ) != undefined then
(
	
	format "obj_anim_layer: %\n" obj_anim_layer
	
	anim_layer_name = AnimLayerManager.getLayerName obj_anim_layer
	format "anim_layer_name: %\n" anim_layer_name
	
	--AnimLayerManager.setLayerName obj_anim_layer "RENAMED"
	
	AnimLayerManager.setLayerMute obj_anim_layer true
	
)
else
	AnimLayerManager.enableLayers #( obj ) pos:true rot:true
