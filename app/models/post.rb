class Post < ActiveRecord::Base

  belongs_to :topic
  belongs_to :user

  # add - associate votes to/with Post so can later call `post.votes`
  # add - dependent :destroy so votes are destroyed if parent post is deleted (ergo association between vote and Post)
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings

  default_scope { order('rank DESC') }

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  after_create :create_favorite

  # following - 'votes' is an implied self.votes
  def up_votes
  # find total - pass value: 1 to 'where' >> fetches collection of votes inc 1 >> then call count on collection, totaling all upvotes
    votes.where(value: 1).count
  end


  def down_votes
  # find total - pass value: -1 to 'where' >> where(value: -1) >> fetches only votes with value of -1 >> call count on collection, totaling all upvotes
    votes.where(value: -1).count
  end


  def points
  # sum method (ActiveRecord) add value of all post votes >> pass :value to 'sum' to tell attribute to sum the collection
    votes.sum(:value)
  end


  def update_rank
     age_in_days = (created_at - Time.new(1970,1,1)) / 1.day.seconds
     new_rank = points + age_in_days
     update_attribute(:rank, new_rank)
   end


   def create_favorite
     Favorite.create(user: self.user, post: self)
     FavoriteMailer.new_post(self).deliver_now
   end
end
