

/** Load content and create dialog
 */
function createPhaseMakerDialog =
(
	format "\n"; print ".loadContentAndCreateDialog()"
	current_dir	= getFilenamePath(getSourceFileName())
	
	
	/* LOAD CONTENT FROM FOLDERS */
	ContentLoader	= ContentLoader_v path:(current_dir+"/content") ini:( getSourceFileName()) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")
	
	ContentLoader.Dialog.title = "PhaseMaker"
	
	/* CREATE UI */
	--ContentLoader.create() --width:512
	ContentLoader.create width:168 --lockHeight:true
	
	
	/* LOAD RIGS */
	--DIALOG_content_animmaker.DL_rig_select.items = #(" ") + (RigWrapper_v()).getNamesOfRigsInScene() -- first item empty + rig names
	--DIALOG_content_animmaker.DL_rig_select.selection = 2 -- select first rig name
	
)

