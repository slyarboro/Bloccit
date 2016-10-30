 class User < ActiveRecord::Base

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :votes, dependent: :destroy
    has_many :favorites, dependent: :destroy

    # register inline callback {self.email = email.downcase} directly after [the before_save] callback
    before_save { self.email = email.downcase }
    before_save { self.role ||= :member }

    before_create :generate_auth_token

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

    enum role: [:member, :admin]

    # following method takes `post` object and uses `where` to retrieve user's favorites when `post_id` matches "post id"
    # if user has favorited `post` ..will return array of one item
    # if user has not favorited `post` ..will return empty array
    # calling "first" on the array returns either respective favorite or "nil" depending on user's action
    def favorite_for(post)
      favorites.where(post_id: post.id).first
    end

    def avatar_url(size)
      gravatar_id = Digest::MD5::hexdigest(self.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    end

    # def self.avatar_url(user, size)
    #  gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    #  "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    # end

    # above added/switched with former to test generate_auth_token failing test

    def generate_auth_token
      loop do
        self.auth_token = SecureRandom.base64(64)
        break unless User.find_by(auth_token: auth_token)
      end
    end
  end
