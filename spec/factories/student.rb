FactoryGirl.define do
  sequence :last_name do |n|
    "Publisher #{n}"
  end

  factory :student do
    last_name
    congregation
  end
    
  factory :brother do
    last_name
    first_name "John"
    congregation
    use_for_no1 true
    use_for_bh false
    use_for_adult true

    factory :elder do
      use_for_bh true
      use_for_advanced true
    end

    factory :boy do
      use_for_adult false
      use_for_advanced false
    end

    factory :inactive_brother do
      is_active false
    end
  end

  factory :sister do
    last_name
    first_name "Betty"
    congregation
    use_for_assistant true
    use_for_adult true
    use_for_advanced true

    factory :girl do
      use_for_adult false
      use_for_advanced false
    end
  end
end
