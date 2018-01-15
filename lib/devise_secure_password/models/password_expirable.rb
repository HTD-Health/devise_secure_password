require 'devise_secure_password/hooks/password_expirable'

module Devise
  module Models
    module PasswordExpirable
      extend ActiveSupport::Concern

      included do
        before_save :update_password_changed
      end

      def need_change_password?
        if expire_password_after_valid?
          self.password_changed_at.nil? || self.password_changed_at < expire_password_after.seconds.ago
        else
          false
        end
      end

      def need_change_password!
        self.update(password_changed_at: expire_password_after.seconds.ago) if expire_password_after_valid?
      end

      protected

      def expire_password_after_valid?
        expire_password_after.is_a?(Integer) || expire_password_after.is_a?(Float)
      end

      def expire_password_after
        self.class.expire_password_after
      end

      def update_password_changed
        self.password_changed_at = Time.now if (self.new_record? || self.encrypted_password_changed?) && !self.password_changed_at_changed?
      end

      module ClassMethods
        Devise::Models.config(self, :expire_password_after)
      end
    end
  end
end
