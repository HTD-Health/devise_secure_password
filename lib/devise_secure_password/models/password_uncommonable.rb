require 'levenshtein'

module Devise
  module Models
    module PasswordUncommonable
      extend ActiveSupport::Concern

      included do
        validate :password_not_to_be_common
        validate :password_not_to_be_similar_to_email
      end

      def password_not_to_be_common
        if (CommonPassword.table_exists? && CommonPassword.where("lower(password) = ?", password.downcase).exists?) || get_top_100_000_passwords.include?(password.downcase)
          errors.add(:password, :commonly_used)
        end
      end

      def password_not_to_be_similar_to_email
        if Levenshtein.distance(email.downcase, password.downcase) < 3 || Levenshtein.distance(email.downcase.split('@')[0], password.downcase) < 3
          errors.add(:password, :email_as_password)
        end
      end

      private

      def get_top_100_000_passwords
        passwords = []

        f = File.open('./lib/devise_secure_password/helpers/100000_top_passwords.txt', 'r+')
        f.each_line { |line| passwords << line.chomp.downcase }
        f.close

        passwords
      end
    end
  end
end
