FactoryGirl.define do
  factory :user do 
    sequence(:name)    { |n| "Pietro #{n}" }
    sequence(:surname) { |n| "Donatini #{n}" }
    sequence(:email)   { |n| "pietro.donatini#{n}@unibo.it" }

    password    "pippo123"
    affiliation "Unibo"
  end
end




