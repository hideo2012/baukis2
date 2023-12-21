$(document).on("turbolinks:load", () => {
	$("div.button-wrapper").on("click", 
					"button#update-entries-button", () => {
		combine_ids("approved")
		combine_ids("canceled")
		$("div.button-wrapper form").submit()
	}) // end of onclick

	function combine_ids( target ) {
		checked_ids = []
		unchecked_ids = []
		$( "table.entries input." + target ).each( 
						(index, elem) => {
			if ( $(elem).prop( "checked" ) ) {
				checked_ids.push( $(elem).data( "entry-id" ) )
			} else {
				unchecked_ids.push( $(elem).data( "entry-id" ) )
			}
		})
		$( "#form_" + target ).val( checked_ids.join(":") )
		$( "#form_not_" + target ).val( unchecked_ids.join(":") )
	} // end of function

})
