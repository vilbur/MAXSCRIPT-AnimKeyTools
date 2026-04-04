clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/main_script.ms" )	--"./main_script.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/Lib/frameButtonRcMenu/frameButtonRcMenu.ms" )	--"./Dialogs/TrackbarTools/frameButtonRcMenu/frameButtonRcMenu.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/Lib/trackbarDialogTicker/trackbarDialogTicker.ms" )	--"./Dialogs/TrackbarTools/trackbarDialogTicker/trackbarDialogTicker.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/Lib/TrackbarToolsCallback/TrackbarToolsCallback.ms" )	--"./Dialogs/TrackbarTools/Lib/TrackbarToolsCallback/TrackbarToolsCallback.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/trackbarToolsDialog.ms" )	--"./Dialogs/TrackbarTools/trackbarToolsDialog.ms"


/*
	THIS WORKS AS TOGGLE
		
	CREATE \ DESTROY DIALOG

*/ 

/*------------------------------------------------------------------------------
	KILL DIALOG
--------------------------------------------------------------------------------*/
if not (try( GetDialogPos DIALOG_time_slider_tools != [0,0] )catch( false ) )then
(
	try( cui.UnRegisterDialogBar DIALOG_time_slider_tools )catch()
	
	try( destroyDialog DIALOG_time_slider_tools )catch()
)
/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/
else if showTimeSlider() then
	trackbarToolsDialog() --"./Dialogs/TrackbarTools/trackbarToolsDialog.ms"