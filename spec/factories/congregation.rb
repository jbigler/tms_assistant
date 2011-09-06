FactoryGirl.define do
  factory :congregation do
    sequence( :name ) { |n| "Congregation #{n}" }
    language
    number_of_schools 1
  end
end
