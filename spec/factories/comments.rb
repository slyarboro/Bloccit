include RandomData

FactoryGirl.define do
  factory :comments do
    user RandomData
    post RandomData
    body RandomData.random_sentence
  end
end
