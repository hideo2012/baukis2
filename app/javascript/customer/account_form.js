const input_flag = { 
	'home' : "input#customer_inputs_home_address", 
	'work' : "input#customer_inputs_work_address" 
}

function toggle_address_fields( kind ) {
  let checked = $( input_flag[kind] ).prop("checked");
  $("fieldset#" + kind + "-address-fields input").prop("disabled", !checked);
  $("fieldset#" + kind + "-address-fields select").prop("disabled", !checked);
}


$(document).on("redy turbolinks:load", ()=> {
  if ($("div.confirming").length) return;

  toggle_address_fields("home");
  toggle_address_fields("work");

  $(input_flag['home']).on("click", () => {
    toggle_address_fields("home");
  });

  $(input_flag['work']).on("click", () => {
    toggle_address_fields("work");
  });

});
