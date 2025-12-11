filein( getFilenamePath(getSourceFileName()) + "/main_script.ms" )	--"./main_script.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/showTimeSlider/showTimeSlider.ms" )	--"./Lib/showTimeSlider/showTimeSlider.ms"

/** Load content and create dialog
 */
function loadContentAndCreateDialog =
(
	--format "\n"; print ".loadContentAndCreateDialog()"
	current_dir	= getFilenamePath(getSourceFileName())
	
	
	/* LOAD CONTENT FROM FOLDERS */
	ContentLoader	= ContentLoader_v path:(current_dir+"/AnimTools/content") ini:( getSourceFileName()) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")
	
	ContentLoader.Dialog.title = "AnimTools"

	/* CREATE UI */
	ContentLoader.create() --width:512
)


loadContentAndCreateDialog()
