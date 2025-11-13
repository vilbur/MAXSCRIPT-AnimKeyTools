
filein( getFilenamePath(getSourceFileName()) + "/includes.ms" )	--"./includes.ms"

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
