source 'https://rubygems.org'
ruby '2.2.0'
gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'bootstrap-sass'
gem 'devise'
gem 'pg'
gem 'puma'
gem 'pundit'
gem 'slim-rails'
gem 'rails_12factor', group: :production
#gem 'keyziio', github: "safenetlabs/ruby-keyziio-agent"
#gem 'keyziio_client', github: "safenetlabs/ruby-keyziio-client"
gem 'keyziio', :git => 'https://github.com/safenetlabs/ruby-keyziio-agent.git'
gem 'keyziio_client', :git => 'https://github.com/safenetlabs/ruby-keyziio-client.git'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_21]
  gem 'quiet_assets'
  gem 'rails_layout'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
end
