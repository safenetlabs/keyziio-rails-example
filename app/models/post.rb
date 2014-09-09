# require 'keyziio'
# require 'keyziio_client'
# require 'json'
require 'base64'
require 'securerandom'

class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessor :encrypted_content
  # before_save :encrypt_post
  # after_find :decrypt_post


  before_save :encrypt
  after_find :decrypt

  def encrypt
    # Get keychain key from the memory cache
    keychain_key = KeyziioCache.cache.read(self.user.keychain_id)
    kz_user = KZClient.new(self.user.keychain_id, self.user.access_token, Base64.decode64(keychain_key))
    self.content = kz_user.encrypt_buffer(content, self.title + '_key')
  end

  def decrypt
    self.encrypted_content = content
    # Get the keychain key from the memory cache
    keychain_key = KeyziioCache.cache.read(self.user.keychain_id)
    kz_user = KZClient.new(self.user.keychain_id, self.user.access_token, Base64.decode64(keychain_key))
    begin
      self.content = kz_user.decrypt_buffer(content) if kz_user
    rescue RestClient::InternalServerError
      true
    end
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
