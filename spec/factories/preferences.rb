FactoryGirl.define do
  factory :preference, class: Preferential::Preference do
    name "foo"
    value true
  end
end
