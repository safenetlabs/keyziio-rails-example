require 'active_support'

#use kza throughout for calls to keyziio service
module KeyziioCache

  @cache = ActiveSupport.Cache.lookup_store(:memory_store)

  def self.cache
    @cache
  end

end