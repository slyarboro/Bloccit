class User < ActiveRecord::Base

# register inline callback {self.email = email.downcase} directly after [the before_save] callback
  before_save {self.email = email.downcase}
  before_save {self.name = name.to_s.split.map(&:capitalize).join(' ')}

# ensure name is present with respective lengths
   validates :name, length: { minimum: 1, maximum: 100 }, presence: true

# Ensure new users will have valid password
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

  # alternative to [.map] (above) ? *brittany
  #  def format_name
  #    if name
  #      name_array = []
  #      name.split.each do |name_part|
  #        name_array << name_part.capitalize
  #      end
  #      self.name = name_array.join[" "]
  #    end
  #  end

 end
