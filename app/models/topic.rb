class Topic < ActiveRecord::Base

  has_many :posts, dependent: :destroy
  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings

  # temporary commenting out for 46privatetopics in order to reflect content in checkpoint
  # validates :name, length: { minimum: 5 }, presence: true
  # validates :description, length: { minimum: 15 }, presence: true

  # scope :visible_to, -> { where(public: true) }
  scope :visible_to, -> (user) { user ? all : where(public: true) }


end
