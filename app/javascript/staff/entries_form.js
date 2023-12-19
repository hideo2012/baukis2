$(document).on("turbolinks:load", () => {
	$("div.button-wrapper").on("click", "button#update-entries-button", () => {
		console.log("---js ? ---")
		approved = []
		not_approved = []
		canceled = []
		not_canceled = []

		$( "table.entries input.approved" ).each( (index, elem) => {
			if ( $(elem).prop( "checked" ) ) {
				approved.push( $(elem).data( "entry-id" ) )
			} else {
				not_approved.push( $(elem).data( "entry-id" ) )
			}
		})

		$( "table.entries input.canceled" ).each( (index, elem) => {
			if ( $(elem).prop( "checked" ) ) {
				canceled.push( $(elem).data( "entry-id" ) )
			} else {
				not_canceled.push( $(elem).data( "entry-id" ) )
			}
		})

		$( "#form_approved" ).val( approved.join(":") )
		$( "#form_not_approved" ).val( not_approved.join(":") )
		$( "#form_canceled" ).val( canceled.join(":") )
		$( "#form_not_canceled" ).val( not_canceled.join(":") )

		$("div.button-wrapper form").submit()
	})
})
