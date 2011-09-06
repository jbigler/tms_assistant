FactoryGirl.define do
  sequence :week_of do |n|
    Date.civil( 2008, 6, 2 ) + ( n * 7 )
  end

  factory :schedule do
    week_of
    has_review false
    language

    factory :review_schedule do
      has_review true
    end
  end
end
