require 'keyziio'

class RegistrationsController < Devise::RegistrationsController
  def create
    super
    user = params[:user]
    print "Creating user #{user['name']}\n"

    agent = Keyziio::Agent.new('cnZNqHoOXDML9eSSZI')
    response = agent.create_user("#{user['name']}", "friendly_#{user['name']}")
    print response
  end
end