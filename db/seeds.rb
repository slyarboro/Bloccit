require 'random_data'

# Create users
5.times do
   User.create!(
   name: RandomData.random_name,
   email: RandomData.random_email,
   password: RandomData.random_sentence
   )
end
users = User.all

# Create topics
15.times do
   Topic.create!(
     name: RandomData.random_sentence,
     description: RandomData.random_paragraph
   )
 end
 topics = Topic.all

# Create posts
50.times do
  post = Post.create!(
    user: users.sample,
    topic: topics.sample,
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
    )

  # update time post was created
  post.update_attribute(:created_at, rand(10.minutes .. 1.year).ago)

  # create between 1-5 votes for each post >> [-1, 1].sample randomly creates either up/down vote
  rand(1..5).times {post.votes.create!(value: [-1, 1].sample, user: users.sample)}
end
posts = Post.all

# Create comments
100.times do
  Comment.create!(
    user: users.sample,
    post: posts.sample,
    body: RandomData.random_paragraph
    )
end

# Create an admin user
 admin = User.create!(
   name:     'Admin User',
   email:    'admin@example.com',
   password: 'helloworld',
   role:     'admin'
 )

# Create a member
 member = User.create!(
   name:     'Member User',
   email:    'member@example.com',
   password: 'helloworld'
 )


puts "Seeds finished"
puts "#{User.count} users created"
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{(Vote.count)} votes created"
