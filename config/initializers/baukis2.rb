Rails.application.configure do
  config.baukis2 = {
    staff: { host: "baukis2.example.com", path: "" },
    admin: { host: "baukis2.example.com", path: "admin" },
    customer: { host: "example.com", path: "mypage" },
    #restrict_ip_address: false
    #restrict_ip_address: true
    restrict_ip_address: ENV["RESTRICT_IP_ADDRESS"] == "1"
  }
end
