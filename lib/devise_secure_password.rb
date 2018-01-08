require "devise_secure_password/engine"
require "devise"

module DeviseSecurePassword
end

module Devise
  # Validate password for strength
  mattr_accessor :password_regex
  @@password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!"#$%&'()*+,-.\/:;<=>?@\\\[\]^_`{|}~])/
end

Devise.add_module :password_validatable, model: 'devise_secure_password/models/password_validatable'
