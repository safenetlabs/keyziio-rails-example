class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, if: :new_record?
  after_create :create_keyziio_user
  has_many :posts

  def create_keyziio_user
    KeyziioAgent.kza.create_user(self.id, self.email)
  end

  def set_default_role
    self.role ||= :user
  end

end
