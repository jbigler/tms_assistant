FactoryGirl.define do
  factory :special_date do
    congregation
    week_of
    is_cancelled true
    is_review_postponed false

    factory :circuit_assembly do
      event "Circuit Assembly"
      is_review_postponed true
    end

    factory :circuit_overseer do
      event "Circuit Overseer Visit"
      is_review_postponed true
      is_cancelled false
    end

    factory :district_convention do
      event "District Convention"
    end
  end
end
