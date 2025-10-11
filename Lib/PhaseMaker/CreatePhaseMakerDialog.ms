

/** Load content and create dialog
 */
function createPhaseMakerDialog =
(
	format "\n"; print ".loadContentAndCreateDialog()"
	current_dir	= getFilenamePath(getSourceFileName())
	
	
	/* LOAD CONTENT FROM FOLDERS */
	ContentLoader	= ContentLoader_v path:(current_dir+"/content") title:"PhaseMaker" width:168 ini:( getSourceFileName()) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/content-animaker") ini:( getSourceFileName()) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")
	
	--ContentLoader.Dialog.title = "PhaseMaker"
	
	/* CREATE UI */
	--ContentLoader.create() --width:512
	--Dialog = ContentLoader.create width:168 --lockHeight:true
	--Dialog = ContentLoader.create width:168 lockWidth:true
	Dialog = ContentLoader.create() --lockWidth:true
	
	
	Dialog.register()
	
	/* LOAD RIGS */
	--if DIALOG_phasemaker != undefined then 
	if DIALOG_phasemaker.DL_rig_select != undefined then -- if used only for DEVELOP 
	(
		DIALOG_phasemaker.DL_rig_select.items = #(" ") + (RigWrapper_v()).getNamesOfRigsInScene() -- first item empty + rig names
		DIALOG_phasemaker.DL_rig_select.selection = 2 -- select first rig name
		
	)
	--format "DIALOG_phasemaker: %\n" DIALOG_phasemaker
)

