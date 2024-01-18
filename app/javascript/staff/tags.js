//require("jquery-ui")
//require("tag-it")

const parent_tag = 'ul#tag-root'
const input_target = '.tag-input-text'
const template = 'div#template li'

$(document).on("turbolinks:load", () => {
	if ( !$(parent_tag).length ) return;

	const msg_id = $('#tag-ajax').data('message-id')
	const path = $('#tag-ajax').data('path')
	//console.log('-- id:path -->[' + msg_id + ' : ' + path + ']')

	$(".tag-input").click( function() {
		var input_text = $.trim( $(input_target).val() )

		if ( !input_text.length ) return
		var labels = $(parent_tag + ' span').map( function(i, elem) {
			return $(elem).text()
		}).get()
		if ( labels.includes( input_text ) ) {
			$( input_target ).val('')
			return
		}

		$.post( path, { label: input_text }, function(msg) {
			if ( msg !== 'ok' ) return
			$( template ).clone(true)
				.appendTo( parent_tag )
				.children('span').text( input_text )
			$( input_target ).val('')
		})
	}); // end of click

	$(".tag-delete").click( function() {
		let target = $(this).parent()
		let target_label = target.children('span').text()
		$.ajax({
			type: "DELETE", url: path, data: { label: target_label }
		}).done( function(msg) {
			if ( msg !== 'ok' ) return
			target.remove()
		}) 
	}); // end of click
})

// for  app/view/staff/messages/show.html.erb

		
