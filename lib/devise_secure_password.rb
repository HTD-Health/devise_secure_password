require "devise_secure_password/engine"
require "devise"

module DeviseSecurePassword
end

module Devise
  # Validate password for strength
  mattr_accessor :password_regex
  @@password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!"#$%&'()*+,-.\/:;<=>?@\\\[\]^_`{|}~])/

  # Number of old passwords in archive
  mattr_accessor :password_archiving_count
  @@password_archiving_count = 5
end

Devise.add_module :password_validatable, model: 'devise_secure_password/models/password_validatable'
Devise.add_module :password_archivable, model: 'devise_secure_password/models/password_archivable'
Devise.add_module :password_uncommonable, model: 'devise_secure_password/models/password_uncommonable'

require 'devise_secure_password/models/old_password'
require 'devise_secure_password/models/common_password'
