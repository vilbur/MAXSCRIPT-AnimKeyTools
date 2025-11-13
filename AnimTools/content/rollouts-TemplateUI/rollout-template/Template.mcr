/**  
 */
macroscript	template_foo_script
category:	"content-Template"
buttontext:	"foo_script"
toolTip:	"foo_script"
--icon:	"#(path, index)"
(
	
	--on IsEnabled return Filters.Is_EPolySpecifyLevel #{2..5}
	--on IsVisible return Filters.Is_EPolySpecifyLevel #{2..5}
	--on IsChecked Do (
	--	try (
	--
	--	)
	--	catch ( false )
	--)
	--
	--on execute do (
	--	try (
	--		messageBox "Execute" beep:false
	--	)
	--	catch()
	--)
	--
	--on AltExecute type do (
	--	try (
	--		messageBox "Alt execute" beep:false
	--	)
	--	catch()
	--)
)
