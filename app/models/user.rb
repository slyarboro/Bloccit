class User < ActiveRecord::Base

# register inline callback {self.email = email.downcase} directly after [the before_save] callback
  before_save { self.email = email.downcase if email.present? }

# ensure name is present with respective lengths
   validates :name, length: { minimum: 1, maximum: 100 }, presence: true

# ensure new users will have valid password
# ensure user's updated password still complies with specs
# [allow_blank: true] skips validation if no new password is given
  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true

# ensure email address is valid and complies with specs
   validates :email,
             presence: true,
             uniqueness: { case_sensitive: false },
             length: { minimum: 3, maximum: 254 }

# adds methods to set and authenticate; requires the [password_digest] attribute             
   has_secure_password

end
