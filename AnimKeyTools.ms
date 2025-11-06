clearListener(); print("Cleared in:\n"+getSourceFileName())

global DIALOG_phasemaker
global DIALOG_time_slider_tools

if PHASE_LENGTH == undefined then 
	global PHASE_LENGTH = 1



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



/*------------------------------------------------------------------------------
	MACROS - imported in production
	
	DEVELOPMENT: this file is imported in *.mcr files bellow
	
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/TrackbarTools.mcr" )	--"./TrackbarTools.mcr"

filein( getFilenamePath(getSourceFileName()) + "/PhaseMaker.mcr" )	--"./PhaseMaker.mcr"
