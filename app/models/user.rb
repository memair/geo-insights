class User < ApplicationRecord
  before_destroy :revoke_token

  has_many :places, dependent: :delete_all

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:memair]

  validates :latest_latitude, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, allow_nil: true
  validates :latest_longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true

  after_create :update_latest_location

  def self.from_memair_omniauth(omniauth_info)
    data        = omniauth_info.info
    credentials = omniauth_info.credentials

    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email:    data['email'],
        password: Devise.friendly_token[0,20],
        memair_access_token: credentials['token']
      )
    end

    user.memair_access_token = credentials['token']
    user.time_zone = data['time_zone']
    user.save
    user
  end

  def get_locations_last_7_days
    user = Memair.new(self.memair_access_token)
    query = 'query{Locations(from_timestamp: "last 7 days" to_timestamp: "today" first: 10000 order_by: timestamp order: asc){timestamp lat lon}}'
    user.query(query)['data']['Locations']
  end

  def get_latest_location
    user = Memair.new(self.memair_access_token)
    query = 'query{Locations(order: desc order_by: timestamp first: 1){timestamp lat lon}}'
    user.query(query)['data']['Locations']&.first
  end

  def update_latest_location
    latest_location = get_latest_location
    if latest_location
      self.latest_latitude  = latest_location['lat']
      self.latest_longitude = latest_location['lon']
    end
  end
  
  private
    def revoke_token
      user = Memair.new(self.memair_access_token)
      query = 'mutation {RevokeAccessToken{revoked}}'
      user.query(query)
    end
end
