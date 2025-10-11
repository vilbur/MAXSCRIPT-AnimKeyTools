clearListener(); print("Cleared in:\n"+getSourceFileName())

global DIALOG_content_animmaker

global PHASE_LENGTH


/*------------------------------------------------------------------------------
	DEPENDENCY
--------------------------------------------------------------------------------*/

/* UI FRAMEWORK */ 
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms"

/* GLOBAL COLOR NAMES */ 
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-COLOR_NAMES/COLOR_NAMES.ms" )	--"./../MAXSCRIPT-COLOR_NAMES/COLOR_NAMES.ms"



/*------------------------------------------------------------------------------
	COMMON
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./Lib/ObjectControllerKeys/ObjectControllerKeys.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/RigWrapper/RigWrapper.ms" )	--"./Lib/RigWrapper/RigWrapper.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/KeyFrameManager/KeyFrameManager.ms" )	--"./Lib/KeyFrameManager/KeyFrameManager.ms"



--/*------------------------------------------------------------------------------
--	TrackbarTools
---------------------------------------------------------------------------------*/
--
--
--filein( getFilenamePath(getSourceFileName()) + "/Lib/frameButtonRcMenu/frameButtonRcMenu.ms" )	--"./Lib/frameButtonRcMenu/frameButtonRcMenu.ms"
--
----filein( getFilenamePath(getSourceFileName()) + "/Lib/walkCycleAnimator/walkCycleAnimator.ms" )	--"./Lib/walkCycleAnimator/walkCycleAnimator.ms"
--
--
--filein( getFilenamePath(getSourceFileName()) + "/Lib/TrackbarTools/trackbarToolsDialog.ms" )	--"./Lib/TrackbarTools/trackbarToolsDialog.ms"
--
--
--/*------------------------------------------------------------------------------
--	MACROS - imported in production
--	
--	DEVELOPMENT: this file is imported in *.mcr files bellow
--	
----------------------------------------------------------------------------------*/
--
--filein( getFilenamePath(getSourceFileName()) + "/TrackbarTools/TrackbarTools.mcr" )	--"./TrackbarTools/TrackbarTools.mcr"
--
--
--filein( getFilenamePath(getSourceFileName()) + "/PhaseMaker/PhaseMaker.mcr" )	--"./PhaseMaker/PhaseMaker.mcr"
--
--
