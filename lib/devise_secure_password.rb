require "devise_secure_password/engine"
require "devise"

module DeviseSecurePassword
  module Controllers
    autoload :Helpers, 'devise_secure_password/controllers/helpers'
  end
end

module Devise
  # Validate password for strength
  mattr_accessor :password_regex
  @@password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!"#$%&'()*+,-.\/:;<=>?@\\\[\]^_`{|}~])/

  # Number of old passwords in archive
  mattr_accessor :password_archiving_count
  @@password_archiving_count = 5

  # Should the password expire (e.g 3.months)
  mattr_accessor :expire_password_after
  @@expire_password_after = 3.months
end


Devise.add_module :password_validatable, model: 'devise_secure_password/models/password_validatable'
Devise.add_module :password_archivable, model: 'devise_secure_password/models/password_archivable'
Devise.add_module :password_uncommonable, model: 'devise_secure_password/models/password_uncommonable'
Devise.add_module :password_expirable, controller: :password_expired, model: 'devise_secure_password/models/password_expirable', route: :password_expired

require 'devise_secure_password/routes'
require 'devise_secure_password/models/old_password'
require 'devise_secure_password/models/common_password'
require 'devise_secure_password/models/database_authenticable_patch'
