require("jquery-ui")
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
		// TODO 追加前表示に同じものあるかチェックしろ。(サーバ上は無視されOK)
		$.post( path, { label: input_text }, (data) => {
			if ( data !== 'ok' ) {
				console.log( '== ng ==' + data )
				return
			}
			$( template ).clone(true)
				.appendTo( parent_tag )
				.children('span').text( input_text )
			$( input_target ).val('')
		})
	});

	$(".tag-delete").click( function() {
		$(this).parent().remove()

	});
})


// for  app/view/staff/messages/show.html.erb

		
