module Devise
  module Models
    module PasswordValidatable
      extend ActiveSupport::Concern

      included do
        validates :password, format: { with: password_regex, message: :password_format }, if: :password_required?
      end

      protected

      module ClassMethods
        Devise::Models.config(self, :password_regex)
      end
    end
  end
end
