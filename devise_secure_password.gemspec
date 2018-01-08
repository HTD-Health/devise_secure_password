$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise_secure_password/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise_secure_password"
  s.version     = DeviseSecurePassword::VERSION
  s.authors     = ["maciekmichalik"]
  s.email       = ["michalikmaciej1995@gmail.com"]
  s.homepage    = "https://github.com/HealthTechDevelopers/devise_secure_password"
  s.summary     = "Devise extension for enchansing security."
  s.description = "Devise extension for enchansing security."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "devise"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_bot_rails"
end
