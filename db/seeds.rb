require 'random_data'

# Create posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end

assignment_post = Post.find_or_create_by!(
  title: "Entitlement",
  body: "Apropos, no?"
)

posts = Post.all


# Create comments
100.times do
  Comment.find_or_create_by!(
    post: assignment_post,
    body: "Body language"
)
end


puts "Seeds finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
