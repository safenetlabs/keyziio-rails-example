require 'json'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, if: :new_record?
  after_create :create_keyziio_user
  has_many :posts

  def setup_client_session
    if KeyziioCache.cache.read(self.keychain_id) == nil
      # Create a client instance and inject key
      kz_user = KZClient.new(self.keychain_id, self.access_token)
      # get session public key from the keyziio client lib
      session_key = kz_user.get_session_key

      # Get user keychain for the user key part
      keychain_response = KeyziioAgent.kza.get_keychain(self.keychain_id)

      # Send key part back to be rewrapped with user session public
      wrapped_key_part = KeyziioAgent.kza.wrap_key_part(JSON.parse(keychain_response)['keypart'], session_key)

      # Now, inject wrapped key in the client
      user_key = kz_user.construct_user_key(wrapped_key_part)

      # Cache kz_user object
      KeyziioCache.cache.write(self.keychain_id, user_key)
    end
  end

  def init_keyziio_client
    access_token = KeyziioAgent.kza.get_client_token(self.keychain_id)
    self.update_attributes(:access_token => access_token)
    self.setup_client_session
  end

  def create_keyziio_user
    keychain_id = KeyziioAgent.kza.create_keychain(self.id)
    self.update_attributes(:keychain_id => keychain_id)
    # access_token = KeyziioAgent.kza.get_client_token(self.keychain_id)
    # self.update_attributes(:keychain_id => keychain_id, :access_token => access_token)
    #self.after_database_authentication
    self.init_keyziio_client
  end

  def after_database_authentication
    # This is a devise callback, which is initiated after successfully authenticating
    self.init_keyziio_client
  end


  def set_default_role
    self.role ||= :user
  end

end
