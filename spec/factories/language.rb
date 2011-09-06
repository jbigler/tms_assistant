FactoryGirl.define do
  sequence :name do |n|
    "Language #{n}"
  end

  sequence :code do |n|
    "l#{n}"
  end

  factory :language do
    name
    code
  end
end
