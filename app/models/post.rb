require 'keyziio'
require 'keyziio_client'
require 'json'

class Post < ActiveRecord::Base
  belongs_to :user

  def self.encrypt_post (user, content)
    agent = Keyziio::Agent.new('cnZNqHoOXDML9eSSZI')
    response = agent.get_user(user)
    client = KZClient.new
    client.inject_user_key(JSON.parse(response)['private_key'], JSON.parse(response)['id'])
    client.encrypt_buffer(content, 'u3_key1')
  end

  def self.decrypt_post (user, content)
    agent = Keyziio::Agent.new('cnZNqHoOXDML9eSSZI')
    response = agent.get_user(user)
    client = KZClient.new
    client.inject_user_key(JSON.parse(response)['private_key'], JSON.parse(response)['id'])
    begin
      client.decrypt_buffer(content)
    rescue KeyziioDecodeException
      content
    end
  end
end
