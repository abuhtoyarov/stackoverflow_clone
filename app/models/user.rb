class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions
  has_many :answers
  has_many :authorizations

  def owner?(obj)
    obj.try(:user_id) && obj.user_id == id
  end

  def can_vote?(obj)
    !owner?(obj) && obj.votes.find_by(user_id: id).nil?
  end

  def self.find_for_oauth(data)
    auth = Authorization.where(provider: data.provider, uid: data.uid.to_s).first
    return auth.user if auth

    return nil unless data.info.try(:email)

    email = data.info[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0..20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: data.provider, uid: data.uid.to_s)
    user
  end
end
