clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Menus/XmlParser/XmlParser.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/Menus/XmlParser/XmlParser.ms"

/*
Full sequence: save temp → reset → delete temp
*/
function resetWorkspaceWithTemporary =
(
	/* GET CURRENT WORKSPACE */ 
    current_workspace = WorkspaceManager.GetCurrentWorkspaceIdentifier()

	workspace_file = (getDir #TEMP) + "\\..\\en-US\\UI\\Workspaces\\" + current_workspace + ".maxsettings"

	/* GET TEMPORARY WORKSPACE */ 
	temp_workspace = current_workspace + "_temp"

	--temp_name = WorkspaceManager.GetWorkspaceNameWithIdentifier current_workspace + " (TEMP)"

	WorkspaceManager.CreateNewWorkspace temp_workspace temp_workspace

	
	/* CHANGE CURRENT WORKSPACE TO TEMP */ 
	WorkspaceManager.SetCurrentWorkspaceByIdentifier temp_workspace

	/* XmlParser */
	XmlParser = XmlParser_v(workspace_file)
	
	element = XmlParser.getElement "SystemSettings"
	
	/* SET TRACKBAR VISIBLE */ 
	XmlParser.setAttribute element "ShowTrackbar" "true"

	
	/* REVERT CURRENT WORKSPACE */ 
	WorkspaceManager.SetCurrentWorkspaceByIdentifier(current_workspace)

	/* ROSET- show trackbar and time slider */ 
	WorkspaceManager.ResetToDefaults(current_workspace)

	/* DELETE TEMP */ 
    WorkspaceManager.DeleteWorkspace(temp_workspace)
)


temp_workspace = resetWorkspaceWithTemporary()

