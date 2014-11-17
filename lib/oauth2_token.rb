require 'securerandom'

module OAuth2Token
  def self.included(klass)
    klass.class_eval do
      cattr_accessor :default_lifetime
      self.default_lifetime = 1.minute

      belongs_to :user
      belongs_to :client

      before_validation :setup, on: :create
      validates :client, :expires_at, presence: true
      validates :token, presence: true, uniqueness: true

      scope :valid, -> { where('expires_at > ?', Time.now.utc) }
    end
  end

  def expires_in
    (expires_at - Time.now.utc).to_i
  end

  def expired!
    self.expires_at = Time.now.utc
    self.save!
  end

  private

  def setup
    self.token = SecureRandom.base64(64)
    self.expires_at ||= default_lifetime.from_now
  end
end
