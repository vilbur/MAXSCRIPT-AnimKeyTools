/** Show time slider
 */
function showTimeSlider =
(
	format "\n"; print ".showTimeSlider()"
	
	/** FORCE RELOAD WORKSPACE AFTER CHANGE IN FILE TO SHOW TIMESLIDER
	  
	 */
	function forceShowTimeSliderWithWorkspaceReset =
	(
			--format "\n"; print ".forceShowTimeSliderWithWorkspaceReset()"
		/* GET CURRENT WORKSPACE */ 
		current_workspace = WorkspaceManager.GetCurrentWorkspaceIdentifier()
	
		--workspace_file = (getDir #TEMP) + "\\..\\en-US\\UI\\Workspaces\\" + current_workspace + ".maxsettings"
		workspace_file = WorkspaceManager.GetWriteDirectory() + "\\" + current_workspace + ".maxsettings"
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
		
		
	/* CHECK IF SLIDER IS VISIBLE */ 
	if not trackbar.visible then
	(
		msg = "Show 'Time Slider' does not work because of 3Ds Max Bug.\n\n"
		msg += "WORKAROUND:\n\n"
		msg += "1) Right-click on an empty area of the top Toolbar to open UI menu\n\n"
		msg += "2) Click on the \"Time Slider\"\n\n"
		msg += "3) Save current Workspace\n\n"

		
		messageBox msg title:"SHOW TIMESLIDDE"
	)
	
	trackbar.visible --return
)
