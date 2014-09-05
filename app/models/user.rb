class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, if: :new_record?
  after_create :create_keyziio_user
  has_many :posts

  def init_client
    access_token = KeyziioAgent.kza.get_client_token(self.keychain_id)
    self.update_attributes(:access_token => access_token)

    # Create a client instance and inject key

  end

  def create_keyziio_user
    keychain_id = KeyziioAgent.kza.create_keychain(self.id)
    self.update_attributes(:keychain_id => keychain_id)
    # access_token = KeyziioAgent.kza.get_client_token(self.keychain_id)
    # self.update_attributes(:keychain_id => keychain_id, :access_token => access_token)
    #self.after_database_authentication
    self.init_client
  end

  def after_database_authentication
    # This is a devise callback, which is initiated after successfully authenticating
    self.init_client
  end


  def set_default_role
    self.role ||= :user
  end

end
