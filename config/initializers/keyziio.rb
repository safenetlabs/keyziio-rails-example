#use kza throughout for calls to keyziio service
module KeyziioAgent

  @kza = Keyziio::Agent.new(Rails.application.secrets.keyziio_id)

  def self.kza
    @kza
  end

end

