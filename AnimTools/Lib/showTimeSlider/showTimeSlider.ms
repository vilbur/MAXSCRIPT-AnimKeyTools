/** Show time slider
 */
function showTimeSlider =
(
	--format "\n"; print ".showTimeSlider()"
	
	/** FORCE RELOAD WORKSPACE AFTER CHANGE IN FILE TO SHOW TIMESLIDER
	  
	 */
	function forceShowTimeSliderWithWorkspaceReset =
	(
			--format "\n"; print ".forceShowTimeSliderWithWorkspaceReset()"
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
	
	
	/* SHOW TRACKBAR */ 
	trackbar.visible = true

	/* SHOW TIMESLIDER */ 
	timeSlider.setVisible true

	/* FORCE TO SHOW IN UI */ 
	if not trackbar.visible then
		forceShowTimeSliderWithWorkspaceReset()
)
