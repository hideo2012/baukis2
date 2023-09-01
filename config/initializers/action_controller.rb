Rails.application.configure do
  # strong parameter on ::::> false (or delete this file)
  # strong parameter off ::::> true
  config.action_controller.permit_all_parameters = false
end
