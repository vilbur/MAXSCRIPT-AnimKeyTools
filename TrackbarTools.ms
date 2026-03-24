clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/main_script.ms" )	--"./main_script.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/Lib/frameButtonRcMenu/frameButtonRcMenu.ms" )	--"./Dialogs/TrackbarTools/frameButtonRcMenu/frameButtonRcMenu.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/Lib/trackbarDialogTicker/trackbarDialogTicker.ms" )	--"./Dialogs/TrackbarTools/trackbarDialogTicker/trackbarDialogTicker.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/Lib/TrackbarToolsCallback/TrackbarToolsCallback.ms" )	--"./Dialogs/TrackbarTools/Lib/TrackbarToolsCallback/TrackbarToolsCallback.ms"

filein( getFilenamePath(getSourceFileName()) + "/Dialogs/TrackbarTools/trackbarToolsDialog.ms" )	--"./Dialogs/TrackbarTools/trackbarToolsDialog.ms"


/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/

if showTimeSlider() then
	trackbarToolsDialog() --"./Dialogs/TrackbarTools/trackbarToolsDialog.ms"