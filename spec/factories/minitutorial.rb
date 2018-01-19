FactoryBot.define do
  factory :minitutorial do 
    sequence(:name)        { |n| "MinitutorialTitle#{n}" }
    sequence(:description) { |n| "MinitutorialAbstract#{n}" }
  end
end



