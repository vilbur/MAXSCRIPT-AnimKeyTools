

/** Load content and create dialog
 */
function createPhaseMakerDialog =
(
	format "\n"; print ".loadContentAndCreateDialog()"
	current_dir	= getFilenamePath(getSourceFileName())
	
	
	/* LOAD CONTENT FROM FOLDERS */
	ContentLoader	= ContentLoader_v path:(current_dir+"/content") title:"PhaseMaker" width:168 ini:( getSourceFileName() ) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/content-animaker") ini:( getSourceFileName()) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")
	filename_path = getFilenamePath( "path" )
	ContentLoader.Dialog.addlocal "current_time" undefined -- trace chnge of frame in ticker
	ContentLoader.Dialog.addlocal "RigWrapper" undefined -- trace chnge of frame in ticker
	
	/* CREATE UI */
	--ContentLoader.create() --width:512
	--Dialog = ContentLoader.create width:168 --lockHeight:true
	--Dialog = ContentLoader.create width:168 lockWidth:true
	--Dialog = ContentLoader.create() --lockWidth:true
	Dialog = ContentLoader.create height:undefined
	
	Dialog.register()
	
	Dialog.alignToDialog( DIALOG_time_slider_tools ) height:#BOTTOM
	
	format "ROLLOUT_phasemaker_options: %\n" ROLLOUT_phasemaker_options
	--format "ROLLOUT_phasemaker_options.DL_rig_select: %\n" ROLLOUT_phasemaker_options.DL_rig_select
	--
	/* LOAD RIGS */
	if ROLLOUT_phasemaker_options != undefined then 
	(
		rig_select = ROLLOUT_phasemaker_options.DL_rig_select
		
		rig_select.items = (RigWrapper_v()).getNamesOfRigsInScene() + #("DO NOT USE RIG") -- first item empty + rig names
		
		rig_select.selection = 1 -- select first rig name
	)
)

