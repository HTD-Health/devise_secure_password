module Devise
  module Models
    module PasswordArchivable
      extend ActiveSupport::Concern

      included do
        has_many :old_passwords, as: :password_archivable, dependent: :destroy
        before_update :archive_password
        validate :validate_password_archive
      end

      protected

      def validate_password_archive
        errors.add(:password, :taken_in_past) if encrypted_password_changed? and password_archive_included?
      end

      def password_archive_included?
        if self.class.password_archiving_count.is_a?(Integer) && self.class.password_archiving_count > 0
          old_passwords_including_current_change = self.old_passwords.order(id: :desc).limit(self.class.password_archiving_count).to_a
          old_passwords_including_current_change << OldPassword.new(old_password_params)
          old_passwords_including_current_change.each do |old_password|
            dummy                    = self.class.new
            dummy.encrypted_password = old_password.encrypted_password
            return true if dummy.valid_password?(password)
          end
        end

        false
      end

      def old_password_params
        { encrypted_password: encrypted_password_change.first }
      end

      def archive_password
        if encrypted_password_changed?
          if self.class.password_archiving_count.is_a?(Integer) && self.class.password_archiving_count > 0
            old_passwords.create! old_password_params
            old_passwords.order(id: :desc).offset(self.class.password_archiving_count).destroy_all
          else
            old_passwords.destroy_all
          end
        end
      end

      module ClassMethods
        Devise::Models.config(self, :password_archiving_count)
      end
    end
  end
end
