class User < ApplicationRecord
  before_destroy :revoke_token

  has_many :places, dependent: :delete_all

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:memair]

  def self.from_memair_omniauth(omniauth_info)
    data        = omniauth_info.info
    credentials = omniauth_info.credentials

    user = User.where(email: data['email']).first

    unless user
     user = User.create(
       email:    data['email'],
       password: Devise.friendly_token[0,20]
     )
    end

    user.memair_access_token = credentials['token']
    user.time_zone = data['time_zone']
    user.save
    user
  end

  def locations_last_7_days
    user = Memair.new(self.memair_access_token)
    query = 'query{Locations(from_timestamp: "last 7 days" to_timestamp: "today" first: 10000){timestamp lat lon point_accuracy}}'
    user.query(query)['data']['Locations']
  end
  
  private
    def revoke_token
      user = Memair.new(self.memair_access_token)
      query = 'mutation {RevokeAccessToken{revoked}}'
      user.query(query)
    end
end
