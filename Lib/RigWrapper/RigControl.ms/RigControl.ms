/** Rig control
 */
struct RigControl_v
(
	/* construct */
	objs,
	
	/* required */
	
	/* properties */
	LeftRightControls,
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	


	private
	
	/** Set left right controls
	 */
	function setLeftRightControls =
	(
		--format "\n"; print "RigControl_v.setLeftRightControls()"
		
		if objs.count == 2 and ( diff_index = this.findFirstDiff objs[1].name objs[2].name ) > 0 then
		(
			
			--format "diff_index: %\n" diff_index  

			--format "TEST: %\n" (objs[1].name.[index])
			left_and_right_objs = Dictionary #( objs[1].name[diff_index] as name, objs[1] ) #( objs[2].name[diff_index] as name, objs[2] )
			--format "left_and_right_objs: %\n" left_and_right_objs
--			
			--if index > 0 then format "A: % B: %\n" str_a[index] str_b[index]
			LeftRightControls = LeftRightControls_v left:left_and_right_objs[#L] right:left_and_right_objs[#R]
			
		)

		
	),
	
	/* Find index of first different character in two strings
	 */
	function findFirstDiff str_a str_b =
	(
		--a_len = str_a.count
		--b_len = str_b.count
		min_len = amin #(str_a.count, str_a.count)
	
		diff_index = undefined
	
		for i = 1 to min_len while diff_index == undefined do 
			if str_a[i] != str_b[i] then
				diff_index = i
	
		
		if diff_index != undefined then 
			diff_index --return

		/* If both are equal up to min_len, but lengths differ */ 
		else if str_a.count != str_a.count then 
			min_len + 1 --return 
		/* IF STRINGS ARE SAME */ 
		else
			0
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "RigControl.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		this.setLeftRightControls()


	)

)
