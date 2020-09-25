FactoryBot.define do
  factory :user do
    name { "Factory Bot" }
    email { "factory@bot.mail" }
    password { "botpassword123" }
  end
end