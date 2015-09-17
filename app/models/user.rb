
class User < ActiveRecord::Base
  validates :username, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  before_save :session_token, presence: true

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
    puts self.password_digest.class
  end

  def password
    @password
  end

  def is_password?(password)
    return false if self.password_digest.nil?
    pass_digest = BCrypt::Password.new(self.password_digest)
    pass_digest.is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user.nil?
      return nil
    end

    if user.is_password?(password)
      user
    else
      nil
    end
  end

  has_many(
    :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id
  )
  has_many(
    :cat_rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :user_id,
    primary_key: :id
  )
end
