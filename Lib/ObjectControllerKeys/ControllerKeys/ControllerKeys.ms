/** Controller keys
 */
struct ControllerKeys_v
(
	/* construct */
	ctrl, -- controller 

	/* required */
	/* properties */
	keys = #(),

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Filter keys
	 */
	function filterKeys phase =
	(
		--format "\n"; print "ControllerKeys_v.filterKeys()"
		for key_time in keys
			where key_time >= phase[1] and key_time <= phase[2]
				collect key_time
	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "ControllerKeys.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
