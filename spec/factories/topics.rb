# define new factory for topics that generate..
  # topic with random name and description
  # all-topic factory generates one-topic with info
FactoryGirl.define do
   factory :topic do
     name RandomData.random_name
     description RandomData.random_sentence
   end
end
