FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Quick #{n}" }
    sequence(:email) { |n| "user.#{n}@saturnstudio.com" }
    password "password" 
    confirmed_at Time.new.to_s
    confirmation_sent_at Time.new.to_s
    password_confirmation { |u| u.password } 

    factory :member do
      email "member@saturnstudio.com"
    end

    factory :admin do
      email "admin@saturnstudio.com"
      admin true
    end
  end
end
