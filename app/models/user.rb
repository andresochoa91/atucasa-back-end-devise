class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  validates :email,
    format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, message: "Invalid Email" },
    uniqueness: { case_sensitive: false },
    length: 4..254
  
  validates :password,
    length: { minimum: 8 },
    confirmation: true,
    on: :create

  validates :password,
    length: { minimum: 8 },
    allow_nil: true,
    on: :update

  validates :password_confirmation,
    length: { minimum: 8 },
    confirmation: true,
    on: :create

  def self.handle_login(email, password)
    user = User.find_by(email: email.downcase)
    if user&.valid_password?(password)
      user_info = Hash.new
      user_info[:token] = CoreModules::JsonWebToken.encode({
        user_id: user.id
      }, 24.hours.from_now)
      return user_info
    else
      return false
    end
  end

end
