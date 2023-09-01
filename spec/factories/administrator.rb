FactoryBot.define do
  factory :administrator do
    sequence(:email) {|n| "admin#{n}@example.com" }
    password { "foobar" }
    suspended { false }
  end
end
