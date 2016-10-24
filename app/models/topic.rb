class Topic < ActiveRecord::Base

  has_many :posts, dependent: :destroy
  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings

  # OG: scope :visible_to, -> { where(public: true) }
  # OM: scope :visible_to, -> (user) { user ? all : where(public: true) }
  # NM: scope :visible_to, -> (user) { user ? all : where(publicly_viewable: true) }
  # BIG:
  scope :visible_to, -> (user) { user ? all : publicly_viewable }

  scope :publicly_viewable, -> { where(public: true) }
  scope :privately_viewable, -> { where(public: false) }
  # OG: scope :privately_viewable, -> { where(private: true) }

end
