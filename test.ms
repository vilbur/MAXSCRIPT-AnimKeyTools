clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Menus/XmlParser/XmlParser.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/Menus/XmlParser/XmlParser.ms"

/*
Full sequence: save temp → reset → delete temp
*/
function resetWorkspaceWithTemporary =
(

	/* Save temporary workspace same as current one
	   
	   USED TO FORCE RELOAD WORKSPACE AFTER CHANGE IN FILE
	
	*/
	function makeTemporaryWorkspace current_identifier =
	(
		--current_identifier = WorkspaceManager.GetCurrentWorkspaceIdentifier()
		temp_identifier = current_identifier + "_temp"
		format "temp_identifier: %\n" temp_identifier
		temp_name = WorkspaceManager.GetWorkspaceNameWithIdentifier current_identifier + " (TEMP)"
	
		WorkspaceManager.CreateNewWorkspace temp_identifier temp_name
	
		/* return identifier for later use -- return */
		temp_identifier
	)

	/* GET CURRENT WORKSPACE */ 
    current_identifier = WorkspaceManager.GetCurrentWorkspaceIdentifier()

	workspace_file = (getDir #TEMP) + "\\..\\en-US\\UI\\Workspaces\\" + current_identifier + ".maxsettings"

	/* GET TEMPORARY WORKSPACE */ 
    temp_identifier = makeTemporaryWorkspace(current_identifier)
	
	/* CHANGE CURRENT WORKSPACE */ 
	WorkspaceManager.SetCurrentWorkspaceByIdentifier temp_identifier

	/* XmlParser */
	XmlParser = XmlParser_v(workspace_file)
	
	element = XmlParser.getElement "SystemSettings"
	format "ELEMENT: %\n" element
	
	/* SET TRACKBAR VISIBLE */ 
	show_trackbar_state = XmlParser.getAttribute element "ShowTrackbar"
	format "SHOW_TRACKBAR_STATE: %\n" show_trackbar_state
	
	
	/* SET ATTRIBUTE VALUE */ 
	XmlParser.setAttribute element "ShowTrackbar" "true"
	show_trackbar_state = XmlParser.getAttribute element "ShowTrackbar"
	format "SHOW_TRACKBAR_STATE: %\n" show_trackbar_state
	
	WorkspaceManager.SetCurrentWorkspaceByIdentifier current_identifier

	WorkspaceManager.ResetToDefaults(current_identifier)

    WorkspaceManager.DeleteWorkspace(temp_identifier)

    /* return */
)


temp_identifier = resetWorkspaceWithTemporary()

