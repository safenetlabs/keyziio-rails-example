class SessionsController < Devise::SessionsController

  def destroy
    # Clear keychain key for this user in the keyziio cache
    KeyziioCache.cache.delete(current_user.keychain_id)
    super
  end
end