require 'random_data'

# Create posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
    )
end

posts = Post.all


# Create comments
100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
    )
end


Post.find_or_create_by(title: "Entitlement", body: "Apropos, no?")


puts "Seeds finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
