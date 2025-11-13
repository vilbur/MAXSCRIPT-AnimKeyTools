macroscript AnimTools_open
category:	"_AnimKeyTools"
buttontext:	"AnimTools"
toolTip:	"Open AnimTools"
(
-- 	filein @"$userscripts\vilTools3\vilTools3-import-scripts.ms"
	--filein @"$userscripts\vilTools3\includes.ms"
	filein @"$userscripts\MAXSCRIPT-AnimKeyTools\AnimTools.ms" --"./AnimTools.ms"
	
	loadContentAndCreateDialog()
)

/*------------------------------------------------------------------------------
	TEST
	
	macros.run "_AnimKeyTools" "AnimTools_open"
--------------------------------------------------------------------------------*/