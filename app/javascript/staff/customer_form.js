//const input_home = "input#form_inputs_home_address";
//const input_work = "input#form_inputs_work_address";
const input_home = "input#customer_inputs_home_address";
const input_work = "input#customer_inputs_work_address";

function toggle_home_address_fields() {
  //const checked = $("input#form_inputs_home_address").prop("checked");
  const checked = $(input_home).prop("checked");
  $("fieldset#home-address-fields input").prop("disabled", !checked);
  $("fieldset#home-address-fields select").prop("disabled", !checked);
}

function toggle_work_address_fields() {
  //const checked = $("input#form_inputs_work_address").prop("checked");
  const checked = $(input_work).prop("checked");
  $("fieldset#work-address-fields input").prop("disabled", !checked);
  $("fieldset#work-address-fields select").prop("disabled", !checked);
}

$(document).on("redy turbolinks:load", ()=> {
  toggle_home_address_fields();
  toggle_work_address_fields();
  //$("input#form_inputs_home_address").on("click", () => {
  $(input_home).on("click", () => {
    toggle_home_address_fields();
  });
  //$("input#form_inputs_work_address").on("click", () => {
  $(input_work).on("click", () => {
    toggle_work_address_fields();
  });
});
