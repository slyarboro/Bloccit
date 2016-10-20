# define new factory for: all-posts that generate one-post with random name and description
FactoryGirl.define do
  factory :post do
    title RandomData.random_sentence
    body RandomData.random_paragraph
    topic
    user
    rank 0.0
  end
end
