include RandomData

 FactoryGirl.define do
   pw = RandomData.random_sentence

   # declare name of factory (:user)
   factory :user do
     name RandomData.random_name

     # Sequences generate unique values (ex: for each user) in specific format (ex: email addresses)
     sequence(:email){|n| "user#{n}@factory.com" }
     password pw
     password_confirmation pw
     role :member
   end
 end
