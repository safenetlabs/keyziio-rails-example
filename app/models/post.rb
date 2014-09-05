# require 'keyziio'
# require 'keyziio_client'
# require 'json'

class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessor :encrypted_content
  # before_save :encrypt_post
  # after_find :decrypt_post


  before_save :encrypt
  after_find :decrypt

  def encrypt
    #kzu = JSON.parse(KeyziioAgent.kza.get_user(self.user.id))
    kzuser = KZClient.new(self.user.keychain_id, self.user.access_token)
    # get session public key from the keyziio client lib
    session_key = kzuser.get_session_key

    kzuser.inject_user_key(kzu['private_key'], kzu['id'])
    self.content = kzuser.encrypt_buffer(content, 'u3_key1')
  end

  def decrypt
    kzu = JSON.parse(KeyziioAgent.kza.get_user(self.user.id))
    kzuser = KZClient.new
    kzuser.inject_user_key(kzu['private_key'], kzu['id'])
    self.encrypted_content = content
    self.content = kzuser.decrypt_buffer(content)
  end

  # def encrypt
  #   kzu = JSON.parse(KeyziioAgent.kza.get_user(self.user.id))
  #   kzuser = KZClient.new
  #   kzuser.inject_user_key(kzu['private_key'], kzu['id'])
  #   self.content = kzuser.encrypt_buffer(content, 'u3_key1')
  # end
  #
  # def decrypt
  #   kzu = JSON.parse(KeyziioAgent.kza.get_user(self.user.id))
  #   kzuser = KZClient.new
  #   kzuser.inject_user_key(kzu['private_key'], kzu['id'])
  #   self.encrypted_content = content
  #   self.content = kzuser.decrypt_buffer(content)
  # end








  # def encrypt_post
  #   # agent = Keyziio::Agent.new('cnZNqHoOXDML9eSSZI')
  #   response = @kza.get_user(current_user)
  #   client = KZClient.new
  #   client.inject_user_key(JSON.parse(response)['private_key'], JSON.parse(response)['id'])
  #   client.encrypt_buffer(:content, 'u3_key1')
  # end
  #
  # def decrypt_post
  #   # agent = Keyziio::Agent.new('cnZNqHoOXDML9eSSZI')
  #   response = @kza.get_user(current_user)
  #   client = KZClient.new
  #   client.inject_user_key(JSON.parse(response)['private_key'], JSON.parse(response)['id'])
  #   begin
  #     client.decrypt_buffer(:content)
  #   rescue KeyziioDecodeException
  #     :content
  #   end
end
