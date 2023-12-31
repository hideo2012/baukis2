const target = "#number-of-unprocessed-messages"

function update_count_unprocessed_messages(){
	const elem = $(target)
	const path = elem.data("path")

	$.get( path, ( data ) => {
		if ( data === "0" ) elem.txt("")
		else elem.text("(" + data + ")")
	})
	.fail( () => { 
		window.location.href = "/login" 
	})
/*
	$.ajax({
		url: path,
		type: 'GET',
		async: true,
		dataType: 'text',
		timeout: 10000
	})
	.done( (data) => {
		elem.text("(" + data + ")")
	})
	.fail( () => { 
		window.location.href = "/login" 
	})
*/
}

$( document ).ready( () => {
	if ( $(target).length )
		window.setInterval( update_count_unprocessed_messages, 1000 * 60 ) //=1minute
})
