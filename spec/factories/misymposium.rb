FactoryGirl.define do
  factory :minisymposium do 
    sequence(:name)        { |n| "MinisymposiumTitle#{n}" }
    sequence(:description) { |n| "MinisymposiumAbstract#{n}" }
  end
end


