require 'levenshtein'

module Devise
  module Models
    module PasswordUncommonable
      extend ActiveSupport::Concern

      included do
        validate :password_not_to_be_common
        validate :password_not_to_be_similar_to_email
      end

      protected

      def password_not_to_be_similar_to_email
        downcased_email = email.downcase
        downcased_password = password.downcase

        if Levenshtein.distance(downcased_email, downcased_password) < 3 || Levenshtein.distance(downcased_email.split('@')[0], downcased_password) < 3
          errors.add(:password, :email_as_password)
        end
      end

      def password_not_to_be_common
        errors.add(:password, :commonly_used) if password_in_top_100_000_passwords? || password_in_custom_common_passwords?
      end

      def password_in_custom_common_passwords?
        CommonPassword.table_exists? && CommonPassword.where("lower(password) = ?", password.downcase).exists?
      end

      def password_in_top_100_000_passwords?
        passwords_file = File.join(File.dirname(__FILE__), "../helpers/100000_top_passwords.txt")

        passwords = []

        f = File.open(passwords_file, 'r')
        f.each_line { |line| passwords << line.chomp.downcase }
        f.close

        passwords.include?(password.downcase)
      end
    end
  end
end
