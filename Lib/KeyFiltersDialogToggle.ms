
/** Key filters dialog toggle
 */
function keyFiltersDialogToggle =
(
	--format "\n"; print ".keyFiltersDialogToggle()"
	
	/*
		Press Key Filters Button
	*/ 
	if ( hwnd = windows.getChildHWND 0 "Set Key Filters" parent:#max ) == undefined then
	(
	
			local maxHWND = windows.getMAXHWND()
			local children = windows.getChildrenHWND maxHWND
			local targetButton = undefined
	
			-- Strategy: Look for the specific "Filters" text if it exists (older Max versions)
			-- OR look for the specific ToolTip handling (harder with UIAccessor)
			
			for child in children do
			(
				-- child[1] = HWND, child[4] = Class Name, child[5] = Window Text
				
				-- Common text labels for this button in various UI setups:
				if matchPattern child[5] pattern:"*Key Filters*" ignoreCase:true or \
				   matchPattern child[5] pattern:"*Filters..." ignoreCase:true then
				(
					targetButton = child[1]
					exit
				)
			)
	
			if targetButton != undefined then
			(
				UIAccessor.PressButton targetButton
				format "Success: Pressed 'Key Filters' button (HWND: %)\n" targetButton
			)
			else
			(
				format "Error: Could not find a button named 'Key Filters' or 'Filters...'.\n"
				format "Your 3ds Max version might use Qt icons which hide the text.\n"
			)
		
	)
	else
		UIAccessor.CloseDialog hwnd[1]
)
