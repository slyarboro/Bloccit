class User < ActiveRecord::Base

  has_many :posts

# register inline callback {self.email = email.downcase} directly after [the before_save] callback
  before_save { self.email = email.downcase}
  before_save { self.role ||= :member }

# ensure name is present with respective lengths
# ensure email address is valid and complies with specs
# ensure new users will have valid password
# ensure user's updated password still complies with specs
# [allow_blank: true] skips validation if no new password is given
# adds methods to set and authenticate; requires the [password_digest] attribute
  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }


  has_secure_password

   enum role: [:member, :admin, :moderator]
end
